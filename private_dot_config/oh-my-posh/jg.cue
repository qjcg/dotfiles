package omp

#OMPConfig: {
	version:     2.0
	final_space: true
	blocks!: [...#Block]
}

#Block: {
	#block

	// If either alignment or type is left unset, no prompt is displayed.
	// This may or may not be a bug, or something to do with the jsonschema -> cue import.
	alignment: *"left" | string
	type:      *"prompt" | string

	// newline defaults to false in schema, I prefer defaulting to true.
	_newline: *true | bool
	if _newline {
		newline: true
	}
}

#Colors: [string]: #color
#Colors: {
	aqua:       "#15c2cb"
	black:      "#000000"
	blue:       "blue"
	lightblue:  "#00c2ff"
	cyan:       "cyan"
	gold:       "#ffe45e"
	green:      "green"
	lightgreen: "#00ff9c"
	hotpink:    "#f141a8"
	pink:       "#c386f1"
	white:      "#ffffff"
	yellow:     "#ebcc34"
	orange:     "#fa9c1b"
}

// See https://www.nerdfonts.com/cheat-sheet
#Symbols: [string]: string
#Symbols: {
	go:                  ""
	k8s:                 "\udb84\udcfe"
	nats:                "N"
	python:              "🐍"
	project:             ""
	triangleHeadedArrow: "❯"
	lambda:              "λ"
	lightning:           "⚡"
	circleDotRight:      "⚆"
	increment:           "∆"
}

#Segment: self = {
	#segment

	style: *"plain" | #segment.style

	if self.powerline_symbol != _|_ {
		style: "powerline"
	}
}

#Segments: [string]: #Segment
#Segments: {
	session: {
		type:       "session"
		foreground: #Colors.white
		template:   "{{ if .SSHSession }} {{ end }}{{ .UserName }}@{{ .HostName }} "
	}

	kubectl: {
		let lb = #Colors.lightblue
		type:       "kubectl"
		foreground: #Colors.blue
		template:   "\(#Symbols.k8s) {{.Context}}{{if .Namespace}}/<\(lb)>{{.Namespace}}</>{{end}} "
	}

	nats: {
		type:       "command"
		foreground: #Colors.orange
		properties: {
			command: "nats context info --json | jq -r .name"
			shell:   "bash"
		}
		template: "\(#Symbols.nats) {{ .Output }} "
	}

	path: {
		type:       "path"
		foreground: #Colors.aqua
		properties: style: "unique"
		template: "{{ .Path }} "
	}

	git: {
		type:       "git"
		foreground: #Colors.hotpink
		properties: {
			branch_icon:  ""
			fetch_status: true
		}
		template: "{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} u{{ .Working.String }}{{ end }}{{ if and (.Staging.Changed) (.Working.Changed) }} |{{ end }}{{ if .Staging.Changed }} s{{ .Staging.String }}{{ end }} "
	}

	project: {
		type:       "project"
		foreground: "#5EADF2"
		template:   "{{if .Version}}<#F3EFF5>is</> \(#Symbols.project) {{.Version}} {{end}}"
	}

	go: {
		type:       "go"
		foreground: #Colors.cyan
		template:   "\(#Symbols.go) {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}"
	}

	python: {
		let lg = #Colors.lightgreen
		type:       "python"
		foreground: #Colors.green
		template:   "\(#Symbols.python) {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ if .Venv }}/<\(lg)>{{ .Venv }}</>{{ end }}{{ end }} "
	}

	prompt: {
		type:       "text"
		foreground: #Colors.gold
		template:   "\(#Symbols.triangleHeadedArrow)"
	}
}

configs: [string]: #OMPConfig

configs: full: {
	blocks: [
		{
			segments: [
				#Segments.session,
				#Segments.kubectl,
				#Segments.nats,
				#Segments.path,
				#Segments.git,
				#Segments.project,
				#Segments.go,
				#Segments.python,
				#Segments.prompt,
			]
		},
	]
}

configs: minimalist: {
	blocks: [
		{
			segments: [
				#Segments.path,
				#Segments.git,

			]
		},

		{
			segments: [
				#Segments.prompt,
			]
		},
	]
}

configs: context: {
	blocks: [
		{
			// TODO: Re-enable #Segments.nats when in daily active use.
			segments: [
				#Segments.kubectl,
				#Segments.python,
			]
		},

		{
			segments: [
				#Segments.path,
				#Segments.git,
			]
		},

		{
			segments: [
				#Segments.prompt,
			]
		},
	]
}
