let g:go_fmt_command = "goimports"

nmap <leader>r <Plug>(go-run)
nmap <leader>i <Plug>(go-info)
nmap <leader>I <Plug>(go-install)
nmap <leader>t <Plug>(go-test)
"nmap <leader>d <Plug>(go-doc-vertical)
nmap <leader>d <Plug>(go-doc-tab)
nmap <leader>D <Plug>(go-doc-browser)


" TEMPLATES

autocmd BufNewFile main.go 0r ~/s/templates/skeleton.main.go
"FIXME: for given language, should choose only one template type
"autocmd BufNewFile *.go 0r ~/s/templates/skeleton.lib.go
