// The Oh My Posh theme definition
//
// https://ohmyposh.dev/docs/configuration/general
package omp

@jsonschema(schema="http://json-schema.org/draft-07/schema#")
@jsonschema(id="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json")

// Final Space
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
final_space?: bool

// Enable Cursor Positioning
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
enable_cursor_positioning?: bool

// FTCS command marks for shell integration
shell_integration?: bool

// Enable OSC99/7/51
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
pwd?: string

// Enable Upgrade Notice
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
upgrade?: {
	interval?: #cache_duration
	source?:   "cdn" | "github"
	auto?:     bool
	notice?:   bool
	...
}

// Patch PowerShell Color Bleed
//
// https://ohmyposh.dev/docs/configuration/general#general-settings
patch_pwsh_bleed?: bool

// Console Title Template
//
// https://ohmyposh.dev/docs/configuration/title#console-title-template
console_title_template?: string
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
palette?: _#defs."/properties/palette"

// Palettes
//
// https://ohmyposh.dev/docs/configuration/colors#palettes
palettes?: {
	// Prompt Template
	template?: string

	// List of palettes
	list?: {
		{[=~".*"]: _#defs."/properties/palette"}
		...
	}
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
}

// Custom text mappings
//
// https://ohmyposh.dev/docs/configuration/general#maps
maps?: {
	...
}

// Async loading
async?: bool

// Tooltips action
//
// https://ohmyposh.dev/docs/configuration/tooltips#tooltips-action
tooltips_action?: "replace" | "extend" | "prepend"

// Version
//
// https://ohmyposh.dev/docs/configuration/general
version?: int

// Extends
//
// https://ohmyposh.dev/docs/configuration/general#extends
extends?: string

// Access token
//
// The initial access token
#access_token: string

// Aliases
//
// Custom value replacement for template parts
#aliases: {
	...
}

// https://ohmyposh.dev/docs/configuration/block
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
	overflow?: "break" | "hide"
	filler?:   #filler
	...
}, _) & {
	...
}]) & {
	// Block type
	//
	// https://ohmyposh.dev/docs/configuration/block#type
	type?: "prompt" | "rprompt"

	// Block alignment
	//
	// https://ohmyposh.dev/docs/configuration/block#alignment
	alignment?: "left" | "right"

	// Newline
	//
	// https://ohmyposh.dev/docs/configuration/block#newline
	newline?: bool

	// Leading diamond
	//
	// https://ohmyposh.dev/docs/configuration/block#leading-diamond
	leading_diamond?: string

	// Trailing diamond
	//
	// https://ohmyposh.dev/docs/configuration/block#trailing-diamond
	trailing_diamond?: string

	// Segments list, prompt elements to display based on context
	//
	// https://ohmyposh.dev/docs/configuration/block#segments
	segments?: [...#segment]
	...
}

// Branch template
//
// the temaplate to use for the branch name, supports {{ .Branch
// }} for the branch name
#branch_template: string

// Cache duration
//
// The duration for which the segment will be cached. This is
// parsed using the `time.ParseDuration` function from the Go
// standard library (see https://pkg.go.dev/time#ParseDuration
// for details).
#cache_duration: =~"^(none|infinite|([0-9]+(h|m|s))+)$"

#color: matchN(>=1, [#color_string, #palette_reference])

// Color string
//
// https://ohmyposh.dev/docs/configuration/colors
#color_string: =~"^(#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})|^([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$|black|red|green|yellow|blue|magenta|cyan|white|default|darkGray|lightRed|lightGreen|lightYellow|lightBlue|lightMagenta|lightCyan|lightWhite|transparent|parentBackground|parentForeground|background|foreground|accent)$"

// Display Mode
//
// Determines whether the segment is displayed always or only if a
// file matching the extensions are present in the current folder
#display_mode: "always" | "files" | "environment" | "context"

// Expires in
//
// Access token expiration time in seconds
#expires_in: int

#extra_prompt: {
	// Prompt Template
	template?:             string
	foreground?:           #color
	foreground_templates?: #templates
	background?:           #color
	background_templates?: #templates
	...
}

// Fetch Version
//
// Fetch the version number
#fetch_version: bool

// Filler
//
// Right aligned filler text, will span the remaining width.
#filler: string

// Folders
//
// The folders to look for when determining if a folder is a
// workspace
#folders: [...string]

// Enable in the HOME folder
//
// Display the segment in the HOME folder
#home_enabled: bool

// Http request timeout
//
// Milliseconds to use for http request timeouts
#http_timeout: int

// Mapped Branches
//
// Custom glyph/text for specific branches
#mapped_branches: {
	...
}

// Missing command text
//
// The string to display when the command is not available
#missing_command_text: string

// Native Fallback
//
// Try to use the WSL 2 native command in a shared Windows drive
// if the Windows executable is not found.
#native_fallback: bool

// Palette reference
//
// https://ohmyposh.dev/docs/configuration/colors#palette
#palette_reference: =~"^p:.*$"

// Refresh token
//
// The initial refresh token
#refresh_token: string

// Segment
//
// https://ohmyposh.dev/docs/configuration/segment
#segment: matchN(100, [matchIf({
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
		extensions?: [...string]
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
		extensions?: [...string]
		folders?: #folders
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
		display_default?: bool
		...
	}
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
		source?: "cli" | "pwsh"
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
	type?: "battery"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Error
		//
		// Show the error context when failing to retrieve the battery
		// information
		display_error?: bool

		// Charging Icon
		//
		// Text/icon to display when charging
		charging_icon?: string

		// discharging Dcon
		//
		// Text/icon to display when discharging
		discharging_icon?: string

		// Charged Icon
		//
		// Text/icon to display when fully charged
		charged_icon?: string

		// Not Charging Icon
		//
		// Text/icon to display when on AC power
		not_charging_icon?: string
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
		icon?: string

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Bazel workspace
		extensions?: [...string]

		// Folders
		//
		// The folders to look for when determining if a folder is a Bazel
		// workspace
		folders?: [...string]
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
		user_id?: string

		// Brewfather API Key (required)
		//
		// Provided by Brewfather's Generate API Key settings option
		api_key?: string

		// ID of the batch in Brewfather (required)
		//
		// At the end of the URL when viewing the batch on the Brewfather
		// site
		batch_id?: string

		// Icon to use to indicate days
		//
		// Appended to a number to indicate days, e.g. 25d
		day_icon?:     string
		http_timeout?: #http_timeout

		// Temperature trend icon, very high positive change
		//
		// Delta between this and prior temperature reading is very high
		// (> 4C by default), available intemplate as .TemperatureTrend
		doubleup_icon?: string

		// Temperature trend icon, high positive change
		//
		// Delta between this and prior temperature reading is high (2C <
		// delta < 4C by default), available intemplate as
		// .TemperatureTrend
		singleup_icon?: string

		// Temperature trend icon, positive change
		//
		// Delta between this and prior temperature reading is positive
		// (0.5C < delta < 2C by default), available intemplate as
		// .TemperatureTrend
		fortyfiveup_icon?: string

		// Temperature trend icon, flat/small change
		//
		// Delta between this and prior temperature and this temperature
		// reading (< +-0.5C change), available intemplate as
		// .TemperatureTrend
		flat_icon?: string

		// Temperature trend icon, v. negative change
		//
		// Delta between this and prior temperature reading is negative
		// (-0.5C > delta > -2C by default), available intemplate as
		// .TemperatureTrend
		fortyfivedown_icon?: string

		// Temperature trend icon, high negative change
		//
		// Delta between this and prior temperature reading is large
		// negative (-2C > delta > -4C by default), available intemplate
		// as .TemperatureTrend
		singledown_icon?: string

		// Temperature trend icon, very high negative change
		//
		// Delta between this and prior temperature reading is very large
		// negative (> -4C by default), available intemplate as
		// .TemperatureTrend
		doubledown_icon?: string

		// Icon for batch in planning
		//
		// Available in template as .StatusIcon
		planning_status_icon?: string

		// Icon for batch being brewed
		//
		// Available in template as .StatusIcon
		brewing_status_icon?: string

		// Icon for batch fermenting
		//
		// Available in template as .StatusIcon
		fermenting_status_icon?: string

		// Icon for batch conditioning
		//
		// Available in template as .StatusIcon
		conditioning_status_icon?: string

		// Icon for completed batch
		//
		// Available in template as .StatusIcon
		completed_status_icon?: string

		// Icon for archived batch
		//
		// Available in template as .StatusIcon
		archived_status_icon?: string
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
		extensions?: [...string]
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
		extensions?: [...string]
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
		extensions?: [...string]
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
		extensions?: [...string]
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
		display_mode?: "always" | "files"
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
		extensions?: [...string]
		folders?: #folders
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
		shell?: string

		// Command
		//
		// the command(s) to run
		command?: string

		// Script
		//
		// A script to run
		script?: string
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
		type?: "ethernet" | "wifi" | "cellular" | "bluetooth"

		// Transfer speed unit
		unit?: "none" | "b" | "bps" | "K" | "Kbps" | "M" | "Mbps" | "G" | "Gbps" | "T" | "Tbps"
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
		extensions?: [...string]
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
		extensions?: [...string]

		// Folders
		//
		// The folders to look for when determining if a folder is a Dart
		// workspace
		folders?: [...string]
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
		extensions?: [...string]
		folders?: #folders
		...
	}
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
	leading_diamond?: string

	// Trailing diamond
	//
	// https://ohmyposh.dev/docs/configuration/segment#trailing-diamond
	trailing_diamond?: string
	...
}, _) & {
	...
}, matchIf({
	type?: "docker"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Fetch Context
		//
		// Fetch the Docker context
		fetch_context?: bool
		display_mode?:  #display_mode
		...
	}
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
		extensions?: [...string]
		folders?: #folders
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
		extensions?: [...string]
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
		always_enabled?: bool

		// Threshold
		//
		// minimum duration (milliseconds) required to enable this segment
		threshold?: number

		// Style
		//
		// The style in which the time will be displayed
		style?: "austin" | "roundrock" | "dallas" | "galveston" | "galvestonms" | "houston" | "amarillo" | "round" | "lucky7"
		...
	}
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
		extensions?: [...string]

		// Folders
		//
		// The folders to look for when determining if a folder is a
		// Flutter workspace
		folders?: [...string]
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "fortran"
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
		// Fortran workspace
		extensions?: [...string]
		folders?: #folders
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
	type?: "gcp"
	...
}, {
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
		fetch_status?: bool

		// Display Worktree Count
		//
		// Display the worktree count or not
		fetch_worktree_count?: bool

		// Display Upstream Icon
		//
		// Display upstream icon or not
		fetch_upstream_icon?: bool

		// Fetch info when in a bare repo
		//
		// Fetch info when in a bare repo or not
		fetch_bare_info?: bool

		// Branch Icon
		//
		// The icon to use in front of the git branch name
		branch_icon?: string

		// Branch Identical Icon
		//
		// The icon to display when remote and local are identical
		branch_identical_icon?: string

		// Branch Ahead Icon
		//
		// The icon to display when the local branch is ahead of its
		// remote
		branch_ahead_icon?: string

		// Branch Behind Icon
		//
		// The icon to display when the local branch is behind its remote
		branch_behind_icon?: string

		// Branch Gone Icon
		//
		// The icon to display when there's no remote branch
		branch_gone_icon?: string

		// Commit Icon
		//
		// Icon/text to display before the commit context (detached HEAD)
		commit_icon?: string

		// Tag Icon
		//
		// Icon/text to display before the tag context
		tag_icon?: string

		// Rebase Icon
		//
		// Icon/text to display before the context when in a rebase
		rebase_icon?: string

		// Cherry-pick Icon
		//
		// Icon/text to display before the context when doing a
		// cherry-pick
		cherry_pick_icon?: string

		// Revert Icon
		//
		// Icon/text to display before the context when doing a revert
		revert_icon?: string

		// Merge Icon
		//
		// Icon/text to display before the merge context
		merge_icon?: string

		// No Commits Icon
		//
		// Icon/text to display when there are no commits in the repo
		no_commits_icon?: string

		// Github Icon
		//
		// Icon/text to display when the upstream is Github
		github_icon?: string

		// Gitlab Icon
		//
		// Icon/text to display when the upstream is Gitlab
		gitlab_icon?: string

		// Bitbucket Icon
		//
		// Icon/text to display when the upstream is Bitbucket
		bitbucket_icon?: string

		// Azure DevOps Icon
		//
		// Icon/text to display when the upstream is Azure DevOps
		azure_devops_icon?: string

		// CodeCommit Icon
		//
		// Icon/text to display when the upstream is CodeCommit
		codecommit_icon?: string

		// Codeberg Icon
		//
		// Icon/text to display when the upstream is Codeberg
		codeberg_icon?: string

		// Git Icon
		//
		// Icon/text to display when the upstream is not known/mapped
		git_icon?: string

		// Untracked files mode
		//
		// Set the untracked files mode for a repository
		untracked_modes?: {
			...
		}

		// Ignore submodules
		//
		// Ignore changes to submodules when looking for changes
		ignore_submodules?: {
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
		fetch_user?:     bool
		status_formats?: #status_formats

		// Status string formats
		//
		// a key, value map representing the remote URL (or a part of that
		// URL) and icon to use in case the upstream URL contains the
		// key. These get precedence over the standard icons
		upstream_icons?: {
			...
		}
		mapped_branches?: #mapped_branches
		branch_template?: #branch_template
		native_fallback?: #native_fallback
		...
	}
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
		parse_mod_file?: bool

		// Parse go.work file
		//
		// Parse go.work file instead of calling out to go to improve
		// performance.
		parse_go_work_file?: bool

		// Extensions
		//
		// The extensions to look for when determining if a folder is a Go
		// workspace
		extensions?: [...string]
		folders?: #folders
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
		stack_ghc_mode?: "always" | "package" | "never"

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Haskell project
		extensions?: [...string]
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
	type?: "http"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// URL
		//
		// The HTTP URL you want to call, supports templates
		url?: string

		// HTTP Method
		//
		// The HTTP method to use
		method?: "GET" | "POST"
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
		url?:          string
		http_timeout?: #http_timeout
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
		extensions?: [...]
		folders?: #folders
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "jujutsu"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Display Status
		//
		// Display the changes in the working copy
		fetch_status?: bool

		// Ignore Working Copy
		//
		// Don't snapshot the working copy, and don't update it
		ignore_working_copy?: bool
		status_formats?:      #status_formats
		native_fallback?:     #native_fallback
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
		extensions?: [...string]
		folders?: #folders
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
		extensions?: [...string]
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
		display_error?: bool

		// Parse kubeconfig
		//
		// Parse kubeconfig files instead of calling out to kubectl to
		// improve performance.
		parse_kubeconfig?: bool

		// Context aliases
		//
		// Custom context names.
		context_aliases?: {
			...
		}
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
		playing_icon?: string

		// SSH Icon
		//
		// Text/icon to show when stopped
		stopped_icon?: string

		// API key
		//
		// The API key used for the API call (Required)
		api_key?: string

		// username
		//
		// The username used for the API call (Required)
		username?:     string
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
		preferred_executable?: "lua" | "luajit"

		// Extensions
		//
		// The extensions to look for when determining if the current
		// directory is a Lua project
		extensions?: [...string]
		folders?: #folders
		...
	}
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
		fetch_status?:    bool
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
		fetch_virtual_env?: bool

		// Display Default
		//
		// Show the name of the virtualenv when it's default
		display_default?:      bool
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Mojo workspace
		extensions?: [...string]
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
		url?: string

		// Http request timeout
		//
		// Milliseconds to use for http request timeouts
		http_timeout?: int

		// Headers
		//
		// A key, value map of Headers to send with the request
		headers?: {
			...
		}
		...
	}
	...
}, _) & {
	...
}, matchIf({
	type?: "nim"
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
		// Nim workspace
		extensions?: [...]
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
		fetch_package_manager?: bool

		// Yarn Icon
		//
		// Icon/text to use for Yarn
		yarn_icon?: string

		// NPM Icon
		//
		// Icon/text to use for NPM
		npm_icon?: string

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Node workspace
		extensions?: [...string]
		folders?: #folders
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
		extensions?: [...string]
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
		extensions?: [...string]
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
		extensions?: [...string]
		folders?: #folders
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
		macos?: string

		// Linux Icon
		//
		// Icon/text to use for Linux
		linux?: string

		// Windows Icon
		//
		// Icon/text to use for Windows
		windows?: string

		// Display Distro Name
		//
		// Display the distro name or icon or not
		display_distro_name?: bool

		// Alpine Icon
		//
		// The icon to use for Alpine
		alpine?: string

		// Aosc Icon
		//
		// The icon to use for Aosc
		aosc?: string

		// Arch Icon
		//
		// The icon to use for Arch
		arch?: string

		// Centos Icon
		//
		// The icon to use for Centos
		centos?: string

		// Coreos Icon
		//
		// The icon to use for Coreos
		coreos?: string

		// Debian Icon
		//
		// The icon to use for Debian
		debian?: string

		// Devuan Icon
		//
		// The icon to use for Devuan
		devuan?: string

		// Raspbian Icon
		//
		// The icon to use for Raspbian
		raspbian?: string

		// Elementary Icon
		//
		// The icon to use for Elementary
		elementary?: string

		// Fedora Icon
		//
		// The icon to use for Fedora
		fedora?: string

		// Gentoo Icon
		//
		// The icon to use for Gentoo
		gentoo?: string

		// Mageia Icon
		//
		// The icon to use for Mageia
		mageia?: string

		// Manjaro Icon
		//
		// The icon to use for Manjaro
		manjaro?: string

		// Mint Icon
		//
		// The icon to use for Mint
		mint?: string

		// Nixos Icon
		//
		// The icon to use for Nixos
		nixos?: string

		// Opensuse Icon
		//
		// The icon to use for Opensuse
		opensuse?: string

		// Redhat Icon
		//
		// The icon to use for Redhat
		redhat?: string

		// Sabayon Icon
		//
		// The icon to use for Sabayon
		sabayon?: string

		// Slackware Icon
		//
		// The icon to use for Slackware
		slackware?: string

		// Ubuntu Icon
		//
		// The icon to use for Ubuntu
		ubuntu?: string

		// Rocky Icon
		//
		// The icon to use for Rocky
		rocky?: string

		// Alma Icon
		//
		// The icon to use for Alma
		alma?: string

		// Android Icon
		//
		// The icon to use for Alma
		android?: string
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
		api_key?: string

		// location
		//
		// Location to use for the API call interpreted only if valid
		// coordinates aren't given. Formatted as
		// <City>,<STATE>,<COUNTRY_CODE>. City name, state code and
		// country code divided by comma. Please, refer to ISO 3166 for
		// the state codes or country codes.
		location?: string

		// units
		//
		// Units of measurement. Available values are standard (kelvin),
		// metric (celsius), and imperial (fahrenheit). Default is
		// standard
		units?:        "standard" | "metric" | "imperial"
		http_timeout?: #http_timeout
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
		folder_separator_icon?: string

		// Folder Separator Template
		//
		// the path which is split will be separated by this template
		folder_separator_template?: =~""

		// Home Icon
		//
		// The icon to display when at $HOME
		home_icon?: string

		// Folder Icon
		//
		// The icon to use as a folder indication
		folder_icon?: string

		// Windows Registry Icon
		//
		// The icon to display when in the Windows registry
		windows_registry_icon?: string

		// The Path Style
		//
		// How to display the current path
		style?: "agnoster" | "agnoster_full" | "agnoster_short" | "agnoster_left" | "short" | "full" | "folder" | "mixed" | "letter" | "unique" | "powerlevel" | "fish"

		// Mapped Locations
		//
		// Custom glyph/text for specific paths
		mapped_locations?: {
			...
		}

		// Maximum Depth
		//
		// Maximum path depth to display without shortening
		max_depth?: int

		// Maximum Width
		//
		// Maximum path width to display for powerlevel style
		max_width?: int | string

		// Enable the Mapped Locations feature
		//
		// Replace known locations in the path with the replacements
		// before applying the style.
		mapped_locations_enabled?: bool

		// Mixed threshold
		//
		// The maximum length of a path segment that will be displayed
		// when using mixed style.
		mixed_threshold?: int

		// Hide the root location
		//
		// Hides the root location, when using agnoster_short style, if it
		// doesn't fit in the last max_depth folders.
		hide_root_location?: bool

		// Color overrides to use to cycle through and color the path per
		// folder
		cycle?: [...string]

		// Cycle the folder_separator_icon
		//
		// Colorize the folder_separator_icon as well when using a cycle.
		cycle_folder_separator?: bool

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
		gitdir_format?: string

		// Display the Cygwin (Linux) style path
		//
		// Display the Cygwin (Linux) style path using cygpath -u $PWD.
		display_cygpath?: bool

		// Directory Length
		//
		// The length of the directory name to display in fish style.
		dir_length?: int

		// Full Length Dirs
		//
		// Indicates how many full length directory names should be
		// displayed in fish style.
		full_length_dirs?: int
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
		extensions?: [...string]
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
		extensions?: [...string]
		folders?: #folders
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
		fetch_status?:   bool
		status_formats?: #status_formats

		// Branch Icon
		//
		// The icon to use in front of the selector branch name
		branch_icon?: string

		// Commit Icon
		//
		// Icon/text to display before the selector changeset
		commit_icon?: string

		// Tag Icon
		//
		// Icon/text to display before the seletor label
		tag_icon?:        string
		branch_template?: #branch_template
		native_fallback?: #native_fallback
		mapped_branches?: #mapped_branches
		...
	}
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
		extensions?: [...string]
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
	powerline_symbol?: string

	// Leading Powerline Symbol
	//
	// https://ohmyposh.dev/docs/configuration/segment#powerline-symbol
	leading_powerline_symbol?: string

	// Flip the Powerline symbol vertically
	//
	// https://ohmyposh.dev/docs/configuration/segment#invert-powerline
	invert_powerline?: bool
	...
}, _) & {
	...
}, matchIf({
	type?: "project"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Always Enabled
		//
		// Always show the segment
		always_enabled?: bool
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
		fetch_stack?: bool

		// Fetch About
		//
		// Fetch the URL and user for the current stack
		fetch_about?: bool
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
		fetch_virtual_env?: bool

		// Display Default
		//
		// Show the name of the virtualenv when it's default
		display_default?:      bool
		fetch_version?:        #fetch_version
		cache_duration?:       #cache_duration
		display_mode?:         #display_mode
		missing_command_text?: #missing_command_text
		version_url_template?: #version_url_template

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Python workspace
		extensions?: [...string]

		// Folders
		//
		// The folders to look for when determining if a folder is a
		// Python workspace
		folders?: [...string]

		// Folder Name Fallback
		//
		// Replace virtual environment names in default_venv_names list
		// with parent folder name
		folder_name_fallback?: bool

		// Default Venv Names
		//
		// Names to replace when folder_name_fallback is true
		default_venv_names?: [...string]
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
		fetch_dependencies?: bool

		// Extensions
		//
		// The extensions to look for when determining if a folder is a
		// Quasar workspace
		extensions?: [...]
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
		extensions?: [...string]
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
		extensions?: [...string]
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
		extensions?: [...]
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
		extensions?: [...]
		folders?: #folders
		...
	}
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
		fetch_status?:    bool
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
		ssh_icon?: string
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
		display_default?: bool
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
		playing_icon?: string

		// Paused Icon
		//
		// Text/icon to show when paused
		paused_icon?: string

		// Stopped Icon
		//
		// Text/icon to show when stopped
		stopped_icon?: string
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
		always_enabled?: bool

		// Status Template
		//
		// The template to use for the status segment
		status_template?: string

		// Status Separator
		//
		// The separator to use between the status segments
		status_separator?: string
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
		url?: string

		// Ride icon
		//
		// Alternative icon for this activity type
		ride_icon?: string

		// Run icon
		//
		// Alternative icon for this activity type
		run_icon?: string

		// Skiing icon
		//
		// Alternative icon for this activity type
		skiing_icon?: string

		// Workout icon
		//
		// Alternative icon for this activity type
		workout_icon?: string

		// Fallback icon
		//
		// Fallback icon for other activity types
		unknown_activity_icon?: string
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
	type?: "svelte"
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
		// directory is a Svelte project
		extensions?: [...string]
		folders?: #folders
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
		fetch_status?:    bool
		status_formats?:  #status_formats
		native_fallback?: #native_fallback
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
		extensions?: [...string]
		folders?: #folders
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
		precision?: int
		...
	}
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
	type?: "tauri"
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
		// directory is a Tauri project
		extensions?: [...string]
		folders?: #folders
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
		fetch_version?: bool
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
	type?: "time"
	...
}, {
	properties?: null | bool | number | string | [...] | {
		// Time Format
		//
		// Format to use, follows the golang standard:
		// https://gobyexample.com/time-formatting-parsing
		time_format?: string
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
		extensions?: [...string]
		folders?: #folders
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
	type?: "v"
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
		// directory is a V project
		extensions?: [...string]
		folders?: #folders
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
		extensions?: [...string]
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
		apikey?:       string
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
		path?: string

		// Fallback value
		//
		// Value to display if registry value cannot be retrieved
		fallback?: string
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
		extensions?: [...string]
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
		extensions?: [...string]
		folders?: #folders
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
		playing_icon?: string

		// Paused Icon
		//
		// Text/icon to show when paused
		paused_icon?: string

		// Stopped Icon
		//
		// Text/icon to show when stopped
		stopped_icon?: string

		// API URL
		//
		// The YTMDA Remote Control API URL
		api_url?:      string
		http_timeout?: #http_timeout
		...
	}
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
		extensions?: [...string]
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
	type!: "angular" | "argocd" | "aurelia" | "aws" | "az" | "azd" | "azfunc" | "battery" | "bazel" | "brewfather" | "buf" | "bun" | "carbonintensity" | "cds" | "cf" | "cftarget" | "cmake" | "command" | "connection" | "crystal" | "dart" | "deno" | "docker" | "dotnet" | "elixir" | "executiontime" | "firebase" | "flutter" | "fortran" | "fossil" | "gcp" | "git" | "gitversion" | "go" | "haskell" | "helm" | "http" | "ipify" | "java" | "jujutsu" | "julia" | "kotlin" | "kubectl" | "lastfm" | "lua" | "mercurial" | "mojo" | "mvn" | "nbgv" | "nightscout" | "nim" | "nix-shell" | "node" | "npm" | "nx" | "ocaml" | "os" | "owm" | "path" | "perl" | "php" | "plastic" | "pnpm" | "project" | "pulumi" | "python" | "quasar" | "r" | "react" | "root" | "ruby" | "rust" | "sapling" | "session" | "shell" | "sitecore" | "spotify" | "status" | "strava" | "svelte" | "svn" | "swift" | "sysinfo" | "talosctl" | "tauri" | "terraform" | "text" | "time" | "ui5tooling" | "umbraco" | "unity" | "upgrade" | "v" | "vala" | "wakatime" | "winreg" | "withings" | "xmake" | "yarn" | "ytm" | "zig"

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
	template?: _#defs."/definitions/segment/properties/template"

	// Templates Logic
	//
	// https://ohmyposh.dev/docs/configuration/segment
	templates_logic?: "first_match" | "join"

	// if the terminal width exceeds this value, the segment will be
	// hidden
	//
	// https://ohmyposh.dev/docs/configuration/segment
	max_width?: int

	// if the terminal width is inferior than this value, the segment
	// will be hidden
	//
	// https://ohmyposh.dev/docs/configuration/segment
	min_width?: int

	// Segment Properties, used to change behavior/displaying
	//
	// https://ohmyposh.dev/docs/configuration/segment#properties
	properties?: {
		...
	}

	// Allow the use of interactive prompt escape sequences
	//
	// https://ohmyposh.dev/docs/configuration/segment
	interactive?: bool

	// Give the segment an alias for use in templates
	//
	// https://ohmyposh.dev/docs/configuration/segment
	alias?: string

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
		strategy?: "folder" | "session"
		...
	}
	...
}

// Status string formats
//
// Override the status format for a specific change. Example:
// {"Added": "Added: %d"}
#status_formats: {
	...
}

// An array of templates
#templates: [..._#defs."/definitions/segment/properties/template"]

// Version Url Template
//
// Template that creates the URL of the version info / release
// notes
#version_url_template: string

// Template text
//
// https://ohmyposh.dev/docs/configuration/templates
_#defs: "/definitions/segment/properties/template": string

// Palette
//
// https://ohmyposh.dev/docs/configuration/colors#palette
_#defs: "/properties/palette": {
	{[=~".*"]: #color}
	...
}
...
