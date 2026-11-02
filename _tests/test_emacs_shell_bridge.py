"""Test Bash aliases with Ghostel's real shell integration, not a helper stub."""

import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest


MODULES = Path(__file__).resolve().parents[1] / "dot_bash_profile.d"
EMACS_DIR = Path(os.environ.get("EMACS_DIR", Path.home() / ".config/emacs"))
GHOSTEL_DIR = os.environ.get("GHOSTEL_DIR")
if not GHOSTEL_DIR:
    candidates = list((EMACS_DIR / "var/elpa").glob("ghostel-*/etc/shell/ghostel.bash"))
    candidates.sort(key=lambda p: tuple(map(int, re.findall(r"\d+", p.parents[2].name))))
    GHOSTEL_DIR = str(candidates[-1].parents[2]) if candidates else None


class EmacsShellBridgeTests(unittest.TestCase):
    def run_shell(self, context, command, *, reverse=False, emacs=True,
                  integration=None, resource=True, expected_status=0):
        modules = ["99-emacs-ghostel.sh", "99-emacs-vterm.sh"]
        if reverse:
            modules.reverse()
        setup = 'source "$EMACS_GHOSTEL_PATH/etc/shell/ghostel.bash"'
        script = "\n".join([
            "shopt -s expand_aliases",
            "PS1='test-prompt> '",
            "PROMPT_COMMAND='test_prompt_hook'",
            setup if integration == "before" else "",
            *(f'source "$MODULES/{module}"' for module in modules),
            # The actual bootstrap loads integration AFTER the user's rc files.
            setup if integration == "after" else "",
            command,
        ])
        with tempfile.TemporaryDirectory() as directory:
            if emacs:
                executable = Path(directory) / "emacs"
                executable.write_text("#!/bin/sh\nexit 0\n")
                executable.chmod(0o755)
            # A minimal PATH proves Ghostel doesn't need an Emacs executable,
            # while retaining sed for the upstream argument encoder.
            (Path(directory) / "sed").symlink_to(shutil.which("sed"))
            env = {
                "PATH": directory,
                "MODULES": str(MODULES),
                "TERM": "xterm-256color",
                "TMUX": "",
                "HOSTNAME": "test-host",
            }
            if resource:
                if not GHOSTEL_DIR:
                    self.skipTest("Install Ghostel or set GHOSTEL_DIR to its resource directory")
                # Exercise the real resource through a path requiring quoting.
                link = Path(directory) / "ghostel install ' $"
                link.symlink_to(GHOSTEL_DIR, target_is_directory=True)
                env["EMACS_GHOSTEL_PATH"] = str(link)
            if context is not None:
                env["INSIDE_EMACS"] = context
            result = subprocess.run(
                ["/bin/bash", "--noprofile", "--norc", "-c", script,
                 "test", 'relative file "quoted" \\name'],
                env=env, capture_output=True, timeout=5,
            )
        self.assertEqual(result.returncode, expected_status, result.stderr.decode())
        if expected_status == 0:
            self.assertEqual(result.stderr, b"")
        return result

    def test_ghostel_aliases_with_real_integration_in_both_load_orders(self):
        for context in ("ghostel", "ghostel,tramp:2.8.0"):
            for reverse in (False, True):
                for integration in ("before", "after", None):
                    for alias, command in (("f", "find-file"), ("d", "dired")):
                        with self.subTest(context=context, reverse=reverse,
                                          integration=integration, alias=alias):
                            result = self.run_shell(context, f'{alias} "$1"',
                                                    reverse=reverse, integration=integration)
                            self.assertEqual(
                                result.stdout,
                                b'\x1b]52;e;"' + command.encode()
                                + b'" "relative file \\"quoted\\" \\\\name" \x1b\\',
                            )

    def test_ghostel_does_not_require_an_emacs_executable(self):
        self.assertTrue(self.run_shell("ghostel", 'f "$1"', emacs=False).stdout.startswith(
            b'\x1b]52;e;"find-file" '))

    def test_ghostel_defers_integration_until_needed(self):
        result = self.run_shell(
            "ghostel", "printf '%s\\0' \"$PS1\" \"$PROMPT_COMMAND\"; "
            "if declare -F ghostel_cmd >/dev/null || declare -F vterm_cmd >/dev/null; "
            "then exit 1; fi",
        )
        self.assertEqual(result.stdout, b"test-prompt> \0test_prompt_hook\0")

    def test_ghostel_preserves_already_loaded_prompt_integration(self):
        result = self.run_shell(
            "ghostel", "before_ps1=$PS1; before_hook=$PROMPT_COMMAND\n"
            f'source "$MODULES/99-emacs-ghostel.sh"\n'
            'f "$1" >/dev/null\n'
            '[[ "$PS1" == "$before_ps1" && "$PROMPT_COMMAND" == "$before_hook" ]]',
            integration="before",
        )
        self.assertEqual(result.stdout, b"")

    def test_ghostel_reuses_integration_after_lazy_loading(self):
        result = self.run_shell(
            "ghostel", 'f "$1" >/dev/null\n'
            'before_hook=$PROMPT_COMMAND\n'
            'd "$1" >/dev/null\n'
            '[[ "$PROMPT_COMMAND" == "$before_hook" ]]',
        )
        self.assertEqual(result.stdout, b"")

    def test_missing_ghostel_resource_reports_actionable_error(self):
        result = self.run_shell("ghostel", 'f "$1"', resource=False, expected_status=127)
        self.assertIn(b"EMACS_GHOSTEL_PATH", result.stderr)
        self.assertNotIn(b"command not found", result.stderr)

    def test_vterm_aliases_keep_the_vterm_protocol(self):
        for context in ("vterm", "vterm,tramp:2.8.0"):
            for reverse in (False, True):
                for alias, command in (("f", "find-file"), ("d", "dired")):
                    with self.subTest(context=context, reverse=reverse, alias=alias):
                        result = self.run_shell(context, f'{alias} "$1"', reverse=reverse,
                                                resource=False)
                        self.assertEqual(
                            result.stdout,
                            b'\x1b]51;E"' + command.encode()
                            + b'" "relative file \\"quoted\\" \\\\name" \x1b\\',
                        )

    def test_other_shells_are_unchanged(self):
        for context in (None, "", "eat", "29.4,comint", "notghostel"):
            with self.subTest(context=context):
                result = self.run_shell(
                    context, "printf '%s\\0' \"$PS1\" \"$PROMPT_COMMAND\"; "
                    "if alias f >/dev/null 2>&1 || alias d >/dev/null 2>&1 "
                    "|| declare -F vterm_cmd >/dev/null "
                    "|| declare -F jg_ghostel_cmd >/dev/null; then exit 1; fi",
                    resource=False,
                )
                self.assertEqual(result.stdout, b"test-prompt> \0test_prompt_hook\0")


if __name__ == "__main__":
    unittest.main()
