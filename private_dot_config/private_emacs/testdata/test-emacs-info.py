"""Exercise local Info installation through real chezmoi and Emacs."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[3]
EMACS_CONFIG = PROJECT / "private_dot_config/private_emacs"


class InfoDeploymentTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="jg-info-test-")
        self.addCleanup(self.temporary.cleanup)
        root = Path(self.temporary.name)
        self.source = root / "source with spaces"
        self.home = root / "home with spaces ' and $literal"
        self.source.mkdir()
        self.home.mkdir()
        self.config = root / "chezmoi.toml"
        self.config.write_text("")
        shutil.copyfile(PROJECT / ".chezmoiignore", self.source / ".chezmoiignore")
        self.environment = os.environ.copy()
        self.environment["HOME"] = str(self.home)
        self.environment.pop("INFOPATH", None)
        for kind in ("CONFIG", "CACHE", "DATA", "STATE"):
            self.environment[f"XDG_{kind}_HOME"] = str(root / f"xdg-{kind.lower()}")
        deployed_source = self.source / "private_dot_config/private_emacs"
        (deployed_source / "docs").mkdir(parents=True)
        self.texi = deployed_source / "docs/ghostel.texi"
        shutil.copyfile(EMACS_CONFIG / "docs/ghostel.texi", self.texi)
        (deployed_source / "lisp/init").mkdir(parents=True)
        shutil.copyfile(
            EMACS_CONFIG / "lisp/init/jg-core.el", deployed_source / "lisp/init/jg-core.el"
        )
        shutil.copyfile(
            PROJECT / "run_after_build-emacs-info.sh.tmpl",
            self.source / "run_after_build-emacs-info.sh.tmpl",
        )
        self.info_dir = self.home / ".config/emacs/var/info"
        self.manual = self.info_dir / "jg-ghostel.info"
        self.catalog = self.info_dir / "dir"

    def apply(self, expect_success=True):
        result = subprocess.run(
            [
                "chezmoi", "--source", str(self.source),
                "--destination", str(self.home), "--config", str(self.config),
                "apply",
            ],
            env=self.environment,
            capture_output=True,
            text=True,
            timeout=30,
        )
        if expect_success:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, "Invalid source unexpectedly built")
        return result

    def check_info_reader(self, mode):
        environment = self.environment.copy()
        environment["JG_INFO_TEST_ROOT"] = str(self.home / ".config/emacs")
        package_root = Path(os.environ.get("EMACS_DIR", Path.home() / ".config/emacs"))
        environment["JG_INFO_PACKAGE_DIR"] = str(package_root / "var/elpa")
        environment["JG_INFO_TEST_MODE"] = mode
        result = subprocess.run(
            [
                os.environ.get("EMACS", "/snap/emacs/current/usr/bin/emacs"),
                "--batch", "-Q", "--load", str(EMACS_CONFIG / "testdata/jg-info-tests.el"),
            ],
            env=environment,
            capture_output=True,
            text=True,
            timeout=30,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_apply_builds_manual_and_local_directory_entry(self):
        self.apply()
        self.assertIn("Node: Top", self.manual.read_text())
        self.assertIn("* Ghostel Workflow: (jg-ghostel).", self.catalog.read_text())
        self.assertTrue((self.home / ".config/emacs/docs/ghostel.texi").exists())

    def test_emacs_discovers_manual_without_replacing_standard_manuals(self):
        self.apply()
        self.check_info_reader("fresh")

    def test_reloading_registration_refreshes_an_already_cached_directory(self):
        self.apply()
        self.check_info_reader("cached")

    def test_repeated_apply_leaves_unchanged_outputs_alone(self):
        self.apply()
        times = (self.manual.stat().st_mtime_ns, self.catalog.stat().st_mtime_ns)
        self.apply()
        self.assertEqual(
            (self.manual.stat().st_mtime_ns, self.catalog.stat().st_mtime_ns), times
        )
        self.assertEqual(self.catalog.read_text().count("* Ghostel Workflow:"), 1)

    def test_missing_manual_is_rebuilt_without_source_changes(self):
        self.apply()
        self.manual.unlink()
        self.apply()
        self.assertIn("Node: Top", self.manual.read_text())

    def test_missing_catalog_is_repaired_without_rebuilding_manual(self):
        self.apply()
        modified = self.manual.stat().st_mtime_ns
        self.catalog.unlink()
        self.apply()
        self.assertEqual(self.manual.stat().st_mtime_ns, modified)
        self.assertIn("* Ghostel Workflow:", self.catalog.read_text())

    def test_deleted_generated_directory_is_recreated(self):
        self.apply()
        shutil.rmtree(self.info_dir)
        self.apply()
        self.assertIn("Node: Top", self.manual.read_text())
        self.assertIn("* Ghostel Workflow:", self.catalog.read_text())

    def test_changed_source_rebuilds_even_when_output_mtime_is_newer(self):
        self.apply()
        future = self.manual.stat().st_mtime_ns + 60_000_000_000
        os.utime(self.manual, ns=(future, future))
        self.texi.write_text(self.texi.read_text().replace(
            "This manual describes", "UPDATED_INFO_CONTENT: This manual describes"
        ))
        self.apply()
        self.assertIn("UPDATED_INFO_CONTENT", self.manual.read_text())

    def test_changed_directory_description_replaces_existing_entry(self):
        self.apply()
        self.texi.write_text(self.texi.read_text().replace(
            "Project and global quake terminals in Emacs.", "Updated workflow guide."
        ))
        self.apply()
        catalog = self.catalog.read_text()
        self.assertIn("Updated workflow guide.", catalog)
        self.assertNotIn("Project and global quake terminals in Emacs.", catalog)
        self.assertEqual(catalog.count("* Ghostel Workflow:"), 1)

    def test_refresh_preserves_unrelated_local_manual_entries(self):
        self.apply()
        other_source = self.source / "other.texi"
        other_source.write_text(
            "@setfilename other.info\n@dircategory Emacs\n@direntry\n"
            "* Other Manual: (other). Another local manual.\n@end direntry\n"
            "@node Top\n@top Other Manual\nOther documentation.\n@bye\n"
        )
        subprocess.run(
            ["makeinfo", "--no-split", "--output=" + str(self.info_dir / "other.info"),
             str(other_source)], check=True, env=self.environment, timeout=30,
        )
        subprocess.run(
            ["install-info", str(self.info_dir / "other.info"), str(self.catalog)],
            check=True, env=self.environment, timeout=30,
        )
        self.apply()
        catalog = self.catalog.read_text()
        self.assertEqual(catalog.count("* Other Manual:"), 1)
        self.assertEqual(catalog.count("* Ghostel Workflow:"), 1)

    def test_generated_state_is_not_deployed_from_the_source_tree(self):
        self.apply()
        generated = self.texi.parent.parent / "var/info"
        generated.mkdir(parents=True)
        (generated / "jg-ghostel.info").write_text("SHOULD_NOT_BE_DEPLOYED")
        (generated / "dir").write_text("SHOULD_NOT_BE_DEPLOYED")
        self.apply()
        self.assertIn("Node: Top", self.manual.read_text())
        self.assertIn("* Ghostel Workflow:", self.catalog.read_text())
        self.assertNotIn("SHOULD_NOT_BE_DEPLOYED", self.manual.read_text())

    def test_failed_build_keeps_last_good_manual_and_catalog(self):
        self.apply()
        manual, catalog = self.manual.read_bytes(), self.catalog.read_bytes()
        original = self.texi.read_text()
        self.texi.write_text(original.replace("@bye", "@unknown-texinfo-command\n@bye"))
        self.apply(expect_success=False)
        self.assertEqual(self.manual.read_bytes(), manual)
        self.assertEqual(self.catalog.read_bytes(), catalog)
        self.texi.write_text(original)
        self.apply()
        self.assertEqual(self.manual.read_bytes(), manual)
        self.assertFalse(list(self.info_dir.glob(".build-*")))


if __name__ == "__main__":
    unittest.main(verbosity=2)
