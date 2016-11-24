filetype plugin indent on
syntax enable
colorscheme elflord

set autochdir
set autoindent
set background=dark
set backspace=indent,eol,start
set foldlevelstart=99		" avoid undesired folding ex: in markdown documents
set hlsearch			" highlight search results
set ignorecase			" case insensitive searches
set laststatus=1		" only show statusbar if >1 windows open
set listchars=tab:>-,eol:$
set mouse=			" disable neovim handling of mouse in-terminal
set nowrap			" don't wrap long lines
set ruler
set shortmess+=I		" disable welcome screen
set smartcase			" case-sensitive search only if specified
set t_Co=256			" Explicitly tell vim that the terminal supports 256 colors
set tabstop=8			" spaces in a tab
set wildmenu			" dmenu-style menu
set wildmode=full

" GVIM
set guioptions-=T


" MAPS
" See :h keycodes
let mapleader=","


nmap <leader>t <ESC>:r !echo '\#' $(date)<CR>
nmap <leader>h <ESC>:set hls!<CR>
nmap <leader>l <ESC>:set list!<CR>
nmap <leader>r <ESC>:source $MYVIMRC<CR>
nmap <leader>s <ESC>:setlocal spell!<CR>
nmap <leader>v <ESC>:0tabnew $MYVIMRC<CR>
nmap <leader>w <ESC>:w !sudo tee %<CR><CR>


" TEMPLATES
autocmd BufNewFile *.html 0r ~/s/templates/index.html
autocmd BufNewFile *.py 0r ~/s/templates/skeleton.py
autocmd BufNewFile .gitignore 0r ~/s/templates/skeleton.gitignore


autocmd Filetype txt,mail,markdown setlocal tw=80 spelllang=en_ca tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd Filetype javascript,yaml,stylus,coffee,css,html,json setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

" via http://arusahni.net/blog/2015/04/switching-to-neovim-part-2.html
if has('nvim')
    let s:editor_root=expand('~/.config/nvim')
else
    let s:editor_root=expand('~/.vim')
endif


" vim-plug plugins
if filereadable(globpath(&rtp, 'autoload/plug.vim'))
	call plug#begin(s:editor_root . '/plugged')

	"" vim-scripts repos
	Plug 'DrawIt'
	Plug 'fountain.vim'
	Plug 'nginx.vim'

	"" github repos
	Plug 'Shutnik/jshint2.vim'
	Plug 'altercation/vim-colors-solarized'
	Plug 'dag/vim-fish'
	Plug 'digitaltoad/vim-jade'
	Plug 'kchmck/vim-coffee-script'
	Plug 'kunstmusik/csound-repl'
	Plug 'ledger/vim-ledger'
	Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
	Plug 'nvie/vim-flake8', {'for': 'python'}
	Plug 'sbl/scvim'
	Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
	Plug 'wavded/vim-stylus'
	Plug 'wilsaj/chuck.vim'
	Plug 'fatih/vim-go'
	Plug 'garyburd/go-explorer'
	Plug 'cespare/vim-toml'
	Plug 'Matt-Deacalion/vim-systemd-syntax', {'for': 'systemd'}
	Plug 'weakish/rcshell.vim'
	Plug 'hashivim/vim-hashicorp-tools'
	Plug 'mattn/emmet-vim'
	Plug 'jaxbot/browserlink.vim'
	Plug 'isRuslan/vim-es6'
	Plug 'shime/vim-livedown'
	Plug 'nathangrigg/vim-beancount'
	Plug 'markcornick/vim-bats'
	Plug 'tpope/vim-jdaddy'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'
	Plug 'tmux-plugins/vim-tmux'
	Plug 'toyamarinyon/vim-swift'

	" add plugins to &runtimepath
	call plug#end()

	map <leader>n :NERDTreeToggle<CR>
endif
