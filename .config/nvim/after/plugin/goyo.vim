" Ref: https://github.com/junegunn/goyo.vim#callbacks

function! s:goyo_enter()
	set noshowmode
	set noshowcmd

	if exists('$TMUX')
		silent !tmux set status off
	endif

	if exists(':Limelight')
		Limelight
	endif
endfunction

function! s:goyo_leave()
	set showmode
	set showcmd

	if exists('$TMUX')
		silent !tmux set status on
	endif

	if exists(':Limelight')
		Limelight!
	endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nmap <Leader>g :Goyo<CR>
xmap <Leader>g :Goyo<CR>
