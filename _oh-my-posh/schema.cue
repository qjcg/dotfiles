package omp

// The Oh My Posh theme definition
//
// https://ohmyposh.dev/docs/configuration/general
@jsonschema(schema="http://json-schema.org/draft-07/schema#")
@jsonschema(id="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json")

// Final Space
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
final_space?: bool | *true

// Enable Cursor Positioning
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
enable_cursor_positioning?: bool | *false

// FTCS command marks for shell integration
shell_integration?: bool | *false

// Enable OSC99/7/51
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
pwd?: string | *""

// Enable Upgrade Notice
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
upgrade_notice?: bool | *false

// Enable automatic upgrades for Oh My Posh (supports
// Windows/macOS only)
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
auto_upgrade?: bool | *false

// Patch PowerShell Color Bleed
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
patch_pwsh_bleed?: bool | *false

// Console Title Template
//
// https://ohmyposh.dev/docs/configuration/title#console-title-template
console_title_template?: string | *"{{ .Shell }} in {{ .Folder }}"
terminal_background?:    #color

// Block array
//
// https://ohmyposh.dev/docs/configuration/general#blocks
blocks!: [...#block]

// Tooltip list, prompt elements to display based on context
//
// https://ohmyposh.dev/docs/configuration/tooltips
tooltips?: [...#segment & (null | bool | number | string | [...] | {
	// The commands for which you want the segment to show
	tips!: [...string]
	...
})]
transient_prompt?: #extra_prompt
valid_line?:       #extra_prompt
error_line?:       #extra_prompt
secondary_prompt?: #extra_prompt
debug_prompt?:     #extra_prompt

// Palette
//
// https://ohmyposh.dev/docs/configuration/colors#palette
palette="palette"?: {
	{[=~".*" & !~"^()$"]: #color}
	...
} | *{
	...
}

// Palettes
//
// https://ohmyposh.dev/docs/configuration/colors#palettes
palettes?: {
	// Prompt Template
	template?: string

	// List of palettes
	list?: {
		{[=~".*" & !~"^()$"]: palette}
		...
	}
	...
} | *{
	...
}

// List of settings to cycle through segment by segment
//
// https://ohmyposh.dev/docs/configuration/cycle
cycle?: [...null | bool | number | string | [...] | {
	foreground?: #color
	background?: #color
	...
}]
accent_color?: #color

// The iTerm2 features to enable
iterm_features?: [..."prompt_mark" | "current_dir" | "remote_host"]

// Config variables to use in templates (can be any value)
//
// https://ohmyposh.dev/docs/configuration/templates#config-variables
var?: {
	...
} | *{
	...
}

#color: matchN(>=1, [#color_string, #palette_reference])

#color_string: =~"^(#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})|^([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$|black|red|green|yellow|blue|magenta|cyan|white|default|darkGray|lightRed|lightGreen|lightYellow|lightBlue|lightMagenta|lightCyan|lightWhite|transparent|parentBackground|parentForeground|background|foreground|accent)$"

#palette_reference: =~"^p:.*$"

#templates: [...#segment.template]

#home_enabled: bool | *false

#fetch_version: bool | *true

#http_timeout: int | *20

#expires_in: int | *0

#access_token: string | *""

#refresh_token: string | *""

#display_mode: "always" | "files" | "environment" | "context" | *"context"

#missing_command_text: string | *""

#version_url_template: string | *""

#status_formats: {
	...
} | *{
	...
}

#folders: [...string]

#branch_max_length: int | *0

#truncate_symbol: string | *""

#native_fallback: bool | *false

#full_branch_path: bool | *true

#mapped_branches: {
	...
} | *{
	...
}

#cache_duration: =~"^(none|infinite|([0-9]+(h|m|s))+)$"

#filler: string

#extra_prompt: {
	// Prompt Template
	template?:             string
	foreground?:           #color
	foreground_templates?: #templates
	background?:           #color
	background_templates?: #templates
	...
} | *{
	...
}

#block: matchN(3, [matchIf({
	type?: "prompt"
	...
}, {
	type!:      _
	alignment!: _
	segments!:  _
	...
}, _) & {
	...
}, matchIf({
	type?: "rprompt"
	...
}, {
	type!:     _
	segments!: _
	...
}, _) & {
	...
}, matchIf({
	type?:      "prompt"
	alignment?: "right"
	...
}, {
	// Block overflow
	//
	// https://ohmyposh.dev/docs/configuration/block#overflow
	overflow?: "break" | "hide" | *""
	filler?:   #filler
	...
}, _) & {
	...
}]) & {
	// Block type
	//
	// https://ohmyposh.dev/docs/configuration/block#type
	type?: "prompt" | "rprompt" | *"prompt"

	// Block alignment
	//
	// https://ohmyposh.dev/docs/configuration/block#alignment
	alignment?: "left" | "right" | *"left"

	// Newline
	//
	// https://ohmyposh.dev/docs/configuration/block#newline
	newline?: bool | *false

	// Leading diamond
	//
	// https://ohmyposh.dev/docs/configuration/block#leading-diamond
	leading_diamond?: string | *""

	// Trailing diamond
	//
	// https://ohmyposh.dev/docs/configuration/block#trailing-diamond
	trailing_diamond?: string | *""

	// Segments list, prompt elements to display based on context
	//
	// https://ohmyposh.dev/docs/configuration/block#segments
	segments?: [...#segment]
	...
}

#segment: matchN(93, [matchIf({
	type?: "project"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Always Enabled
		//
		// Always show the segment
		always_enabled?: bool | *false
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "npm"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is an
		// NPM workspace
		extensions?: [...string] | *["package.json", "package-lock.json"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	style?: "powerline"
	...
}, {
	// Powerline Symbol
	//
	// https://ohmyposh.dev/docs/configuration/segment#powerline-symbol
	powerline_symbol?: string | *"\ue0b0"

	// Leading Powerline Symbol
	//
	// https://ohmyposh.dev/docs/configuration/segment#powerline-symbol
	leading_powerline_symbol?: string | *"\ue0d7"

	// Flip the Powerline symbol vertically
	//
	// https://ohmyposh.dev/docs/configuration/segment#invert-powerline
	invert_powerline?: bool | *false
	...
}, _) & {
	...
}, matchIf({
	style?: "diamond"
	...
}, {
	// Leading diamond
	//
	// https://ohmyposh.dev/docs/configuration/segment#leading-diamond
	leading_diamond?: string | *""

	// Trailing diamond
	//
	// https://ohmyposh.dev/docs/configuration/segment#trailing-diamond
	trailing_diamond?: string | *""
	...
}, _) & {
	...
}, matchIf({
	type?: "az"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Source
		//
		// https://ohmyposh.dev/docs/segments/cloud/az#properties
		source?: "first_match" | "cli" | "pwsh" | *"first_match"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "azd"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "battery"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Error
		//
		// Show the error context when failing to retrieve the battery
		// information
		display_error?: bool | *false

		// Charging Icon
		//
		// Text/icon to display when charging
		charging_icon?: string | *""

		// discharging Dcon
		//
		// Text/icon to display when discharging
		discharging_icon?: string | *""

		// Charged Icon
		//
		// Text/icon to display when fully charged
		charged_icon?: string | *""

		// Not Charging Icon
		//
		// Text/icon to display when on AC power
		not_charging_icon?: string | *""
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "bazel"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Icon
		//
		// The icon representing Bazel's logo
		icon?: string | *"\ue63a"

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Bazel workspace
		extensions?: [...string] | *["*.bazel", "*.bzl", "BUILD", "WORKSPACE", ".bazelrc", ".bazelversion"]

		// Folders
		//
		// The folders to look for when determining if a folder is a Bazel
		// workspace
		folders?: [...string] | *["bazel-bin", "bazel-out", "bazel-testlogs"]
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "buf"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		missing_command_text?: #missing_command_text
		display_mode?:         #display_mode
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Buf workspace
		extensions?: [...string] | *["buf.yaml", "buf.gen.yaml", "buf.work.yaml"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "bun"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		missing_command_text?: #missing_command_text
		display_mode?:         #display_mode
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Bun workspace
		extensions?: [...string] | *["bun.lockb"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "carbonintensity"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		http_timeout?: #http_timeout
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "command"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Shell
		//
		// The shell in which to run the command in. Uses shell -c command
		// under the hood
		shell?: string | *"bash"

		// Command
		//
		// the command(s) to run
		command?: string | *""

		// Script
		//
		// A script to run
		script?: string | *""
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "connection"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Connection type
		//
		// The connection type to display
		type?: "ethernet" | "wifi" | "cellular" | "bluetooth" | *"wifi|ethernet"

		// Transfer speed unit
		unit?: "none" | "b" | "bps" | "K" | "Kbps" | "M" | "Mbps" | "G" | "Gbps" | "T" | "Tbps" | *"none"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "cmake"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// CMake workspace
		extensions?: [...string] | *["*.cmake", "CMakeLists.txt"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "docker"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "dotnet"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// .NET workspace
		extensions?: [...string] | *["*.cs", "*.csx", "*.vb", "*.fs", "*.fsx", "*.sln", "*.slnf", "*.csproj", "*.fsproj", "*.vbproj", "global.json"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "status"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Always Enabled
		//
		// Always show the status
		always_enabled?: bool | *false

		// Status Template
		//
		// The template to use for the status segment
		status_template?: string | *"|"

		// Status Separator
		//
		// The separator to use between the status segments
		status_separator?: string | *"|"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "flutter"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Flutter workspace
		extensions?: [...string] | *["*.dart", "pubspec.yaml", "pubspec.yml", "pubspec.lock"]

		// Folders
		//
		// The folders to look for when determining if a folder is a
		// Flutter workspace
		folders?: [...string] | *[".dart_tool"]
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "fossil"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		native_fallback?: #native_fallback
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "git"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Status
		//
		// Display the local changes or not
		fetch_status?: bool | *true

		// Display Stash Count
		//
		// Display the stash count or not
		fetch_stash_count?: bool | *false

		// Display Worktree Count
		//
		// Display the worktree count or not
		fetch_worktree_count?: bool | *false

		// Display Upstream Icon
		//
		// Display upstream icon or not
		fetch_upstream_icon?: bool | *false

		// Fetch info when in a bare repo
		//
		// Fetch info when in a bare repo or not
		fetch_bare_info?: bool | *false

		// Branch Icon
		//
		// The icon to use in front of the git branch name
		branch_icon?: string | *"\ue0a0 "

		// Branch Identical Icon
		//
		// The icon to display when remote and local are identical
		branch_identical_icon?: string | *"≡"

		// Branch Ahead Icon
		//
		// The icon to display when the local branch is ahead of its
		// remote
		branch_ahead_icon?: string | *"↑"

		// Branch Behind Icon
		//
		// The icon to display when the local branch is behind its remote
		branch_behind_icon?: string | *"↓"

		// Branch Gone Icon
		//
		// The icon to display when there's no remote branch
		branch_gone_icon?: string | *"≢"

		// Commit Icon
		//
		// Icon/text to display before the commit context (detached HEAD)
		commit_icon?: string | *"\uf417"

		// Tag Icon
		//
		// Icon/text to display before the tag context
		tag_icon?: string | *"\uf412"

		// Rebase Icon
		//
		// Icon/text to display before the context when in a rebase
		rebase_icon?: string | *"\ue728"

		// Cherry-pick Icon
		//
		// Icon/text to display before the context when doing a
		// cherry-pick
		cherry_pick_icon?: string | *"\ue29b"

		// Revert Icon
		//
		// Icon/text to display before the context when doing a revert
		revert_icon?: string | *"\uf0e2"

		// Merge Icon
		//
		// Icon/text to display before the merge context
		merge_icon?: string | *"\ue727"

		// No Commits Icon
		//
		// Icon/text to display when there are no commits in the repo
		no_commits_icon?: string | *"\uf594"

		// Github Icon
		//
		// Icon/text to display when the upstream is Github
		github_icon?: string | *"\uf408"

		// Gitlab Icon
		//
		// Icon/text to display when the upstream is Gitlab
		gitlab_icon?: string | *"\uf296"

		// Bitbucket Icon
		//
		// Icon/text to display when the upstream is Bitbucket
		bitbucket_icon?: string | *"\uf171"

		// Azure DevOps Icon
		//
		// Icon/text to display when the upstream is Azure DevOps
		azure_devops_icon?: string | *"\uebe8"

		// CodeCommit Icon
		//
		// Icon/text to display when the upstream is CodeCommit
		codecommit_icon?: string | *"\uf270"

		// Codeberg Icon
		//
		// Icon/text to display when the upstream is Codeberg
		codeberg_icon?: string | *"\uf330"

		// Git Icon
		//
		// Icon/text to display when the upstream is not known/mapped
		git_icon?: string | *"\ue5fb"

		// Branch max length
		//
		// the max length for the displayed branch name where 0 implies
		// full length
		branch_max_length?: int | *0

		// Untracked files mode
		//
		// Set the untracked files mode for a repository
		untracked_modes?: {
			...
		} | *{
			...
		}

		// Ignore submodules
		//
		// Ignore changes to submodules when looking for changes
		ignore_submodules?: {
			...
		} | *{
			...
		}

		// Ignore fetching status in these repo's
		//
		// Ignore fetching status for certain repo's, uses the same logic
		// as the exclude_folders property
		ignore_status?: [...string]

		// Fetch the user
		//
		// Fetch the current configured user for the repository
		fetch_user?:     bool | *false
		status_formats?: #status_formats

		// Status string formats
		//
		// a key, value map representing the remote URL (or a part of that
		// URL) and icon to use in case the upstream URL contains the
		// key. These get precedence over the standard icons
		upstream_icons?: {
			...
		} | *{
			...
		}
		mapped_branches?:  #mapped_branches
		full_branch_path?: #full_branch_path
		native_fallback?:  #native_fallback
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "go"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Parse go.mod file
		//
		// Parse go.mod file instead of calling out to go to improve
		// performance.
		parse_mod_file?: bool | *false

		// Extensions
		//
		// The extensions to look for when determining if a folder is a Go
		// workspace
		extensions?: [...string] | *["*.go", "go.mod"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "dart"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Dart workspace
		extensions?: [...string] | *["*.dart", "pubspec.yaml", "pubspec.yml", "pubspec.lock"]

		// Folders
		//
		// The folders to look for when determining if a folder is a Dart
		// workspace
		folders?: [...string] | *[".dart_tool"]
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "deno"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		missing_command_text?: #missing_command_text
		display_mode?:         #display_mode
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Deno workspace
		extensions?: [...string] | *["*.js", "*.ts", "deno.json"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "crystal"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Crystal workspace
		extensions?: [...string] | *["*.cr", "shard.yml"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "julia"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Julia workspace
		extensions?: [...string] | *["*.jl"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "perl"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Perl workspace
		extensions?: [...string] | *[".perl-version", "*.pl", "*.pm", "*.t"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "php"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// PHP workspace
		extensions?: [...string] | *["*.php", "composer.json", "composer.lock", ".php-version"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "java"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Java workspace
		extensions?: [...] | *["pom.xml", "build.gradle.kts", "build.sbt", ".java-version", ".deps.edn", "project.clj", "build.boot", "*.java", "*.class", "*.gradle", "*.jar", "*.clj", "*.cljc"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "ruby"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Ruby workspace
		extensions?: [...] | *["*.rb", "Rakefile", "Gemfile"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "rust"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Rust workspace
		extensions?: [...] | *["*.rs", "Cargo.toml", "Cargo.lock"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "xmake"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// XMake workspace
		extensions?: [...string] | *["xmake.lua"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "kubectl"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Error
		//
		// Show the error context when failing to retrieve the kubectl
		// information
		display_error?: bool | *false

		// Parse kubeconfig
		//
		// Parse kubeconfig files instead of calling out to kubectl to
		// improve performance.
		parse_kubeconfig?: bool | *true

		// Context aliases
		//
		// Custom context names.
		context_aliases?: {
			...
		} | *{
			...
		}
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "aws"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Default User Profile
		//
		// Display the segment when default user or not
		display_default?: bool | *true
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "node"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Fetch Display Package Manager
		//
		// Assigns the Yarn or NPM icon to .PackageManagerIcon
		fetch_package_manager?: bool | *false

		// Yarn Icon
		//
		// Icon/text to use for Yarn
		yarn_icon?: string | *"\uf011B"

		// NPM Icon
		//
		// Icon/text to use for NPM
		npm_icon?: string | *"\ue71e"

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Node workspace
		extensions?: [...string] | *["*.js", "*.ts", "package.json", ".nvmrc", "pnpm-workspace.yaml", ".pnpmfile.cjs", ".vue"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "azfunc"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "os"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// MacOS Icon
		//
		// Icon/text to use for macOS
		macos?: string | *"\uf179"

		// Linux Icon
		//
		// Icon/text to use for Linux
		linux?: string | *"\uf17c"

		// Windows Icon
		//
		// Icon/text to use for Windows
		windows?: string | *"\ue62a"

		// Display Distro Name
		//
		// Display the distro name or icon or not
		display_distro_name?: bool | *false

		// Alpine Icon
		//
		// The icon to use for Alpine
		alpine?: string | *"\uf300"

		// Aosc Icon
		//
		// The icon to use for Aosc
		aosc?: string | *"\uf301"

		// Arch Icon
		//
		// The icon to use for Arch
		arch?: string | *"\uf303"

		// Centos Icon
		//
		// The icon to use for Centos
		centos?: string | *"\uf303"

		// Coreos Icon
		//
		// The icon to use for Coreos
		coreos?: string | *"\uf305"

		// Debian Icon
		//
		// The icon to use for Debian
		debian?: string | *"\uf306"

		// Devuan Icon
		//
		// The icon to use for Devuan
		devuan?: string | *"\uf307"

		// Raspbian Icon
		//
		// The icon to use for Raspbian
		raspbian?: string | *"\uf315"

		// Elementary Icon
		//
		// The icon to use for Elementary
		elementary?: string | *"\uf309"

		// Fedora Icon
		//
		// The icon to use for Fedora
		fedora?: string | *"\uf30a"

		// Gentoo Icon
		//
		// The icon to use for Gentoo
		gentoo?: string | *"\uf30d"

		// Mageia Icon
		//
		// The icon to use for Mageia
		mageia?: string | *"\uf310"

		// Manjaro Icon
		//
		// The icon to use for Manjaro
		manjaro?: string | *"\uf312"

		// Mint Icon
		//
		// The icon to use for Mint
		mint?: string | *"\uf30e"

		// Nixos Icon
		//
		// The icon to use for Nixos
		nixos?: string | *"\uf313"

		// Opensuse Icon
		//
		// The icon to use for Opensuse
		opensuse?: string | *"\uf314"

		// Redhat Icon
		//
		// The icon to use for Redhat
		redhat?: string | *"\uf316"

		// Sabayon Icon
		//
		// The icon to use for Sabayon
		sabayon?: string | *"\uf317"

		// Slackware Icon
		//
		// The icon to use for Slackware
		slackware?: string | *"\uf319"

		// Ubuntu Icon
		//
		// The icon to use for Ubuntu
		ubuntu?: string | *"\uf31b"

		// Rocky Icon
		//
		// The icon to use for Rocky
		rocky?: string | *"\uf32b"

		// Alma Icon
		//
		// The icon to use for Alma
		alma?: string | *"\uf31d"

		// Android Icon
		//
		// The icon to use for Alma
		android?: string | *"\uf17b"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "path"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Folder Separator Icon
		//
		// The symbol to use as a separator between folders
		folder_separator_icon?: string | *"/"

		// Folder Separator Template
		//
		// the path which is split will be separated by this template
		folder_separator_template?: =~""

		// Home Icon
		//
		// The icon to display when at $HOME
		home_icon?: string | *"~"

		// Folder Icon
		//
		// The icon to use as a folder indication
		folder_icon?: string | *".."

		// Windows Registry Icon
		//
		// The icon to display when in the Windows registry
		windows_registry_icon?: string | *"\uf013"

		// The Path Style
		//
		// How to display the current path
		style?: "agnoster" | "agnoster_full" | "agnoster_short" | "agnoster_left" | "short" | "full" | "folder" | "mixed" | "letter" | "unique" | "powerlevel" | *"agnoster"

		// Mapped Locations
		//
		// Custom glyph/text for specific paths
		mapped_locations?: {
			...
		} | *{
			...
		}

		// Maximum Depth
		//
		// Maximum path depth to display without shortening
		max_depth?: int | *1

		// Maximum Width
		//
		// Maximum path width to display for powerlevel style
		max_width?: int | string | *0

		// Enable the Mapped Locations feature
		//
		// Replace known locations in the path with the replacements
		// before applying the style.
		mapped_locations_enabled?: bool | *true

		// Mixed threshold
		//
		// The maximum length of a path segment that will be displayed
		// when using mixed style.
		mixed_threshold?: int | *4

		// Hide the root location
		//
		// Hides the root location, when using agnoster_short style, if it
		// doesn't fit in the last max_depth folders.
		hide_root_location?: bool | *false

		// Color overrides to use to cycle through and color the path per
		// folder
		cycle?: [...string]

		// Cycle the folder_separator_icon
		//
		// Colorize the folder_separator_icon as well when using a cycle.
		cycle_folder_separator?: bool | *false

		// The folder format
		//
		// Golang string format to apply to the folder name
		folder_format?: =~"%s"

		// The format to use on the start and end folder
		//
		// Golang string format to apply to the start and end folder
		edge_format?: =~"%s"

		// The format to use on first folder of the path
		//
		// Will default to whatever edge_format is set to
		left_format?: =~"%s"

		// The format to use on the last folder of the path
		//
		// Will default to whatever edge_format is set to
		right_format?: =~"%s"

		// The format to use on a git root directory
		//
		// Golang string format to apply to the .git folder
		gitdir_format?: string | *""

		// Display the Cygwin (Linux) style path
		//
		// Display the Cygwin (Linux) style path using cygpath -u $PWD.
		display_cygpath?: bool | *false
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "python"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?: #home_enabled

		// Fetch Virtual Env
		//
		// Fetch the name of the virtualenv or not
		fetch_virtual_env?: bool | *true

		// Display Default
		//
		// Show the name of the virtualenv when it's default
		display_default?:      bool | *true
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Python workspace
		extensions?: [...string] | *["*.py", "*.ipynb", "pyproject.toml", "venv.bak"]

		// Folders
		//
		// The folders to look for when determining if a folder is a
		// Python workspace
		folders?: [...string] | *[".venv", "venv", "virtualenv", "venv-win", "pyenv-win"]

		// Folder Name Fallback
		//
		// Replace virtual environment names in default_venv_names list
		// with parent folder name
		folder_name_fallback?: bool | *"true"

		// Default Venv Names
		//
		// Names to replace when folder_name_fallback is true
		default_venv_names?: [...string] | *[".venv", "venv"]
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "pulumi"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Fetch Stack
		//
		// Fetch the current pulumi stack or not
		fetch_stack?: bool | *false

		// Fetch About
		//
		// Fetch the URL and user for the current stack
		fetch_about?: bool | *false
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "quasar"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Fetch Dependencies
		//
		// Fetch the vite and @quasar/app-vite dependency information or
		// not
		fetch_dependencies?: bool | *true

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Quasar workspace
		extensions?: [...] | *["quasar.config", "quasar.config.js"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "root"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "sapling"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Status
		//
		// Display the local changes or not
		fetch_status?:    bool | *true
		status_formats?:  #status_formats
		native_fallback?: #native_fallback
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "session"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// SSH Icon
		//
		// Text/icon to display first when in an active SSH session
		ssh_icon?: string | *"\uf817"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "shell"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Custom Text
		//
		// Custom glyph/text for specific shells
		custom_text?: {
			...
		} | *{
			...
		}
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "sitecore"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Default
		//
		// Display the segment or not when the Sitecore environment name
		// matches `default`
		display_default?: bool | *true
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "spotify"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Playing Icon
		//
		// Text/icon to show when playing
		playing_icon?: string | *"\ue602"

		// Paused Icon
		//
		// Text/icon to show when paused
		paused_icon?: string | *"\uf8e3"

		// Stopped Icon
		//
		// Text/icon to show when stopped
		stopped_icon?: string | *"\uf04d"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "terraform"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Fetch Version
		//
		// Fetch the version number
		fetch_version?: bool | *false
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "text"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "talosctl"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "time"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Time Format
		//
		// Format to use, follows the golang standard:
		// https://gobyexample.com/time-formatting-parsing
		time_format?: string | *"15:04:05"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "ytm"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Playing Icon
		//
		// Text/icon to show when playing
		playing_icon?: string | *"\ue602 "

		// Paused Icon
		//
		// Text/icon to show when paused
		paused_icon?: string | *"\uf8e3 "

		// Stopped Icon
		//
		// Text/icon to show when stopped
		stopped_icon?: string | *"\uf04d "

		// API URL
		//
		// The YTMDA Remote Control API URL
		api_url?:      string | *"http://127.0.0.1:9863"
		http_timeout?: #http_timeout
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "owm"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// API key
		//
		// The API key used for the api call (Required)
		api_key?: string | *"."

		// location
		//
		// Location to use for the API call interpreted only if valid
		// coordinates aren't given. Formatted as
		// <City>,<STATE>,<COUNTRY_CODE>. City name, state code and
		// country code divided by comma. Please, refer to ISO 3166 for
		// the state codes or country codes.
		location?: string | *"De Bilt,NL"

		// units
		//
		// Units of measurement. Available values are standard (kelvin),
		// metric (celsius), and imperial (fahrenheit). Default is
		// standard
		units?:        "standard" | "metric" | "imperial" | *"standard"
		http_timeout?: #http_timeout
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "elixir"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Elixir workspace
		extensions?: [...string] | *["*.ex", "*.exs"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "executiontime"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Always Enabled
		//
		// Always show the duration
		always_enabled?: bool | *false

		// Threshold
		//
		// minimum duration (milliseconds) required to enable this segment
		threshold?: number | *500

		// Style
		//
		// The style in which the time will be displayed
		style?: "austin" | "roundrock" | "dallas" | "galveston" | "galvestonms" | "houston" | "amarillo" | "round" | "lucky7" | *"austin"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "sysinfo"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Precision
		//
		// number of decimal places to show
		precision?: int | *2
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "strava"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// URL of API with Strava data
		//
		// Url of your api provinding a Strava activity
		url?: string | *""

		// Ride icon
		//
		// Alternative icon for this activity type
		ride_icon?: string | *"\uf206"

		// Run icon
		//
		// Alternative icon for this activity type
		run_icon?: string | *"\ue213"

		// Skiing icon
		//
		// Alternative icon for this activity type
		skiing_icon?: string | *"\ue213"

		// Workout icon
		//
		// Alternative icon for this activity type
		workout_icon?: string | *"\ue213"

		// Fallback icon
		//
		// Fallback icon for other activity types
		unknown_activity_icon?: string | *"\ue213"
		http_timeout?:          #http_timeout
		access_token?:          #access_token
		refresh_token?:         #refresh_token
		expires_in?:            #expires_in
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "svn"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Status
		//
		// Display the local changes or not
		fetch_status?:    bool | *true
		status_formats?:  #status_formats
		native_fallback?: #native_fallback
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "angular"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		missing_command_text?: #missing_command_text
		display_mode?:         #display_mode
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is an Angular project
		extensions?: [...string] | *["angular.json"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "aurelia"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		missing_command_text?: #missing_command_text
		display_mode?:         #display_mode
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is an Aurelia project
		extensions?: [...string] | *["package.json"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "react"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a React project
		extensions?: [...string] | *["package.json"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "nx"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		missing_command_text?: #missing_command_text
		display_mode?:         #display_mode
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is an Nx project
		extensions?: [...string] | *["workspace.json", "nx.json"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "ocaml"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is an OCaml project
		extensions?: [...string] | *["*.ml", "*.mli", "dune", "dune-project", "dune-workspace"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "wakatime"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// apikey
		//
		// The apikey used for the api call (Required)
		apikey?:       string | *"."
		http_timeout?: #http_timeout
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "winreg"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Registry Path
		//
		// The path to the registry key (case insensitive, must use
		// backslashes). Ending with \ will retrieve "(Default)" key in
		// that path.
		path?: string | *""

		// Fallback value
		//
		// Value to display if registry value cannot be retrieved
		fallback?: string | *""
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "withings"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		http_timeout?:  #http_timeout
		access_token?:  #access_token
		refresh_token?: #refresh_token
		expires_in?:    #expires_in
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "plastic"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Status
		//
		// Display the local changes or not
		fetch_status?:   bool | *false
		status_formats?: #status_formats

		// Branch Icon
		//
		// The icon to use in front of the selector branch name
		branch_icon?: string | *"\ue0a0 "

		// Commit Icon
		//
		// Icon/text to display before the selector changeset
		commit_icon?: string | *"\uf417"

		// Tag Icon
		//
		// Icon/text to display before the seletor label
		tag_icon?:          string | *"\uf412"
		truncate_symbol?:   #truncate_symbol
		branch_max_length?: #branch_max_length
		full_branch_path?:  #full_branch_path
		native_fallback?:   #native_fallback
		mapped_branches?:   #mapped_branches
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "brewfather"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Brewfather UserID (required)
		//
		// Provided by Brewfather's Generate API Key settings option
		user_id?: string | *""

		// Brewfather API Key (required)
		//
		// Provided by Brewfather's Generate API Key settings option
		api_key?: string | *""

		// ID of the batch in Brewfather (required)
		//
		// At the end of the URL when viewing the batch on the Brewfather
		// site
		batch_id?: string | *""

		// Icon to use to indicate days
		//
		// Appended to a number to indicate days, e.g. 25d
		day_icon?:     string | *"d"
		http_timeout?: #http_timeout

		// Temperature trend icon, very high positive change
		//
		// Delta between this and prior temperature reading is very high
		// (> 4C by default), available intemplate as .TemperatureTrend
		doubleup_icon?: string | *"↑↑"

		// Temperature trend icon, high positive change
		//
		// Delta between this and prior temperature reading is high (2C <
		// delta < 4C by default), available intemplate as
		// .TemperatureTrend
		singleup_icon?: string | *"↑"

		// Temperature trend icon, positive change
		//
		// Delta between this and prior temperature reading is positive
		// (0.5C < delta < 2C by default), available intemplate as
		// .TemperatureTrend
		fortyfiveup_icon?: string | *"↗"

		// Temperature trend icon, flat/small change
		//
		// Delta between this and prior temperature and this temperature
		// reading (< +-0.5C change), available intemplate as
		// .TemperatureTrend
		flat_icon?: string | *"→"

		// Temperature trend icon, v. negative change
		//
		// Delta between this and prior temperature reading is negative
		// (-0.5C > delta > -2C by default), available intemplate as
		// .TemperatureTrend
		fortyfivedown_icon?: string | *"↘"

		// Temperature trend icon, high negative change
		//
		// Delta between this and prior temperature reading is large
		// negative (-2C > delta > -4C by default), available intemplate
		// as .TemperatureTrend
		singledown_icon?: string | *"↓"

		// Temperature trend icon, very high negative change
		//
		// Delta between this and prior temperature reading is very large
		// negative (> -4C by default), available intemplate as
		// .TemperatureTrend
		doubledown_icon?: string | *"↓↓"

		// Icon for batch in planning
		//
		// Available in template as .StatusIcon
		planning_status_icon?: string | *"\uf8ea"

		// Icon for batch being brewed
		//
		// Available in template as .StatusIcon
		brewing_status_icon?: string | *"\uf7de"

		// Icon for batch fermenting
		//
		// Available in template as .StatusIcon
		fermenting_status_icon?: string | *"\uf499"

		// Icon for batch conditioning
		//
		// Available in template as .StatusIcon
		conditioning_status_icon?: string | *"\ue372"

		// Icon for completed batch
		//
		// Available in template as .StatusIcon
		completed_status_icon?: string | *"\uf7a5"

		// Icon for archived batch
		//
		// Available in template as .StatusIcon
		archived_status_icon?: string | *"\uf187"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "ipify"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// URL
		//
		// The Ipify API URL
		url?:          string | *"https://api.ipify.org"
		http_timeout?: #http_timeout
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "haskell"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Use Stack GHC
		//
		// Get the GHC version used by Stack. Will decrease performance.
		// Boolean indicating whether stack ghc was used available in
		// template as .StackGhc
		stack_ghc_mode?: "always" | "package" | "never" | *"never"

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Haskell project
		extensions?: [...string] | *["*.hs", "*.lhs", "stack.yaml", "package.yaml", "*.cabal", "cabal.project"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "helm"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		display_mode?: #display_mode
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "ui5tooling"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a UI5 project
		extensions?: [...string] | *["*ui5*.y*ml"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "unity"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		http_timeout?: #http_timeout
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "upgrade"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		cache_duration?: #cache_duration
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "vala"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Vala project
		extensions?: [...string] | *["*.vala"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "cf"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Cloud Foundry project
		extensions?: [...string] | *["manifest.yml", "mta.yaml"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "cftarget"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Mode
		//
		// Determines whether the segment is displayed always or only if a
		// file matching the extensions are present in the current folder
		display_mode?: "always" | "files" | *"always"
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "kotlin"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Kotlin project
		extensions?: [...string] | *["*.kt", "*.kts", "*.ktm"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "lastfm"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// User Info Separator
		//
		// Text/icon to show when playing
		playing_icon?: string | *"\ue602"

		// SSH Icon
		//
		// Text/icon to show when stopped
		stopped_icon?: string | *"\uf04d"

		// API key
		//
		// The API key used for the API call (Required)
		api_key?: string | *"."

		// username
		//
		// The username used for the API call (Required)
		username?:     string | *"."
		http_timeout?: #http_timeout
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "lua"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Preferred Executable
		//
		// The preferred executable to use when fetching the version.
		preferred_executable?: "lua" | "luajit" | *"lua"

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Lua project
		extensions?: [...string] | *["*.lua", "*.rockspec"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "swift"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Swift project
		extensions?: [...string] | *["*.swift", "*.SWIFT"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "cds"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a CDS project
		extensions?: [...string] | *[".cdsrc.json", ".cdsrc-private.json", "*.cds"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "r"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is an R project
		extensions?: [...string] | *["*.R", "*.Rmd", "*.Rsx", "*.Rda", "*.Rd", "*.Rproj", ".Rproj.user"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "gcp"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "firebase"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "gitversion"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "mercurial"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Status
		//
		// Display the local changes or not
		fetch_status?:    bool | *false
		status_formats?:  #status_formats
		native_fallback?: #native_fallback
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "mojo"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?: #home_enabled

		// Fetch Virtual Env
		//
		// Fetch the name of the virtualenv or not
		fetch_virtual_env?: bool | *true

		// Display Default
		//
		// Show the name of the virtualenv when it's default
		display_default?:      bool | *true
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Mojo workspace
		extensions?: [...string] | *["*.🔥", "*.mojo", "mojoproject.toml"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "nightscout"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// URL
		//
		// The URL to the Nightscout API
		url?: string | *""

		// Http request timeout
		//
		// Milliseconds to use for http request timeouts
		http_timeout?: int | *500

		// Headers
		//
		// A key, value map of Headers to send with the request
		headers?: {
			...
		} | *{
			...
		}
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "umbraco"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "pnpm"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is an
		// PNPM workspace
		extensions?: [...string] | *["package.json", "pnpm-lock.yaml"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "yarn"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is an
		// Yarn workspace
		extensions?: [...string] | *["package.json", "yarn.lock"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "nix-shell"
	...
}, {
	...
}, _) & {
	...
}, matchIf({
	type?: "zig"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		home_enabled?:         #home_enabled
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is an zig project
		extensions?: [...string] | *["*.zig", "*.zon"]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}]) & {
	// Segment Type
	//
	// https://ohmyposh.dev/docs/configuration/segment
	type!: "az" | "azd" | "aws" | "azfunc" | "argocd" | "angular" | "aurelia" | "battery" | "bazel" | "brewfather" | "buf" | "bun" | "carbonintensity" | "command" | "connection" | "crystal" | "cds" | "cf" | "cftarget" | "cmake" | "docker" | "dotnet" | "dart" | "deno" | "elixir" | "executiontime" | "flutter" | "fossil" | "gcp" | "firebase" | "git" | "gitversion" | "go" | "haskell" | "helm" | "ipify" | "julia" | "java" | "kotlin" | "kubectl" | "lastfm" | "lua" | "mercurial" | "mojo" | "mvn" | "nbgv" | "nightscout" | "nix-shell" | "node" | "npm" | "nx" | "ocaml" | "os" | "owm" | "path" | "perl" | "python" | "php" | "plastic" | "pnpm" | "project" | "pulumi" | "quasar" | "root" | "ruby" | "rust" | "r" | "react" | "sapling" | "session" | "sitecore" | "spotify" | "status" | "shell" | "sysinfo" | "strava" | "svn" | "swift" | "talosctl" | "time" | "text" | "terraform" | "ui5tooling" | "umbraco" | "unity" | "upgrade" | "vala" | "wakatime" | "winreg" | "withings" | "xmake" | "yarn" | "ytm" | "zig"

	// Segment Style
	//
	// https://ohmyposh.dev/docs/configuration/segment#style
	style!: matchN(>=1, ["plain" | "powerline" | "diamond" | "accordion", string])
	foreground?:           #color
	foreground_templates?: #templates
	background?:           #color
	background_templates?: #templates

	// Template text
	//
	// https://ohmyposh.dev/docs/configuration/templates
	template?: string | *""

	// Templates Logic
	//
	// https://ohmyposh.dev/docs/configuration/segment
	templates_logic?: "first_match" | "join"

	// if the terminal width exceeds this value, the segment will be
	// hidden
	//
	// https://ohmyposh.dev/docs/configuration/segment
	max_width?: int | *0

	// if the terminal width is inferior than this value, the segment
	// will be hidden
	//
	// https://ohmyposh.dev/docs/configuration/segment
	min_width?: int | *0

	// Segment Properties, used to change behavior/displaying
	//
	// https://ohmyposh.dev/docs/configuration/segment#properties
	properties?: {
		...
	} | *{
		...
	}

	// Allow the use of interactive prompt escape sequences
	//
	// https://ohmyposh.dev/docs/configuration/segment
	interactive?: bool | *false

	// Give the segment an alias for use in templates
	//
	// https://ohmyposh.dev/docs/configuration/segment
	alias?: string | *""

	// If specified, segment will only render in these folders
	//
	// https://ohmyposh.dev/docs/configuration/segment#include--exclude-folders
	include_folders?: [...string]

	// Exclude rendering in these folders
	//
	// https://ohmyposh.dev/docs/configuration/segment#include--exclude-folders
	exclude_folders?: [...string]

	// Cache settings
	//
	// https://ohmyposh.dev/docs/configuration/segment#cache
	cache?: {
		duration?: #cache_duration

		// Cache strategy
		//
		// https://ohmyposh.dev/docs/configuration/segment#strategy
		strategy?: "folder" | "session" | *"folder"
		...
	} | *{
		...
	}
	...
} | *{
	...
}
...
