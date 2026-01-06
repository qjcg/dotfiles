;;-*-coding: utf-8;-*-
(define-abbrev-table 'go-mode-abbrev-table
  '(
    ("iferr" "if err != nil {
}
" nil :count 5)
   ))

(define-abbrev-table 'go-ts-mode-abbrev-table
  '(
    ("goyektask" "import (
	\"flag\"
	\"fmt\"

	\"github.com/goyek/goyek/v3\"
	\"github.com/goyek/x/cmd\"
)

var lintCmdVersion = flag.String(\"l\", \"v2.6.2\", \"golangci-lint release version\")

var golint = goyek.Define(goyek.Task{
	Name:  \"golint\",
	Usage: \"golangci-lint run --fix\",
	Action: func(a *goyek.A) {
		c := fmt.Sprintf(\"GOTOOLCHAIN=go1.25.4 go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@%s run --fix\", *lintCmdVersion)
		cmd.Exec(a, c)
		a.Log(\"Ran Go linter!\")
	},
})
" nil :count 0)
   ))

(define-abbrev-table 'org-mode-abbrev-table
  '(
    ("daily135" "* Daily 135

** 1 major task [/]
*** TODO

** 3 medium tasks [/]
*** TODO 
*** TODO 
*** TODO 

** 5 small tasks [/]
*** TODO 
*** TODO 
*** TODO 
*** TODO 
*** TODO 


* Meetings

** MEETING TITLE

* Shutdown [/]

** TODO final slack/email review
** TODO update todo list with any meeting action items
** TODO review next day on calendar
** TODO choose top 3 objectives for your day
*** TODO 
*** TODO 
*** TODO 

** TODO schedule those objectives as appointments for yourself, in the white space of your calendar
" nil :count 2)
    ("daily3" "* Creative Before Reactive

* Daily 3

** 3 tasks [0/3]
*** TODO GSS SWOT for Oli
*** TODO 
*** TODO 

* Meetings

** MEETING TITLE

* Shutdown [0/5]

** TODO final slack/email review
** TODO update todo list with any meeting action items
** TODO review next day on calendar
** TODO choose top 3 objectives for your day
*** TODO 
*** TODO 
*** TODO 

** TODO schedule those objectives as appointments for yourself, in the white space of your calendar
" nil :count 1)
    ("daily333" "* Daily 333

** 3h focused work [/]
*** TODO

** 3 short tasks [/]
*** TODO

** 3 routine tasks [/]
*** TODO



* Meetings

** Meeting Title
- 

* Shutdown [/]

** TODO final slack/email review
** TODO update todo list with any meeting action items
** TODO review next day on calendar
** TODO choose top 3 objectives for your day
*** TODO 
*** TODO 
*** TODO 

** TODO schedule those objectives as appointments for yourself, in the white space of your calendar
" nil :count 3)
   ))

