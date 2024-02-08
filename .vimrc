" significant portions taken from <https://www.mojotech.com/blog/vimrc-tutorial/>

" disable `vi` compatibility
set nocompatible

" backspace behavior
set backspace=indent,eol,start

" safety
set modelines=0

set t_Co=256

" SHOW TRAILING WHITESPACE WOOHOO
set list
set listchars=tab:>-,trail:.,extends:#,nbsp:.

" hide buffers instead of closing them
set hidden

" command history & undo history
set history=100
set undolevels=100

" indenting
set expandtab " change tabs to spaces--will this fuck with makefiles?
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set smarttab
set autoindent
set copyindent
set nowrap " controversial

" fold (hide) regions of code if asked
" set foldenable
set nofoldenable
set foldmethod=indent
set foldlevel=1

" ruler at column limit
set ruler
" set colorcolumn=100 " imo better than 80

" line numbers
set nu

" syntax highlighting
syntax on
filetype on
filetype plugin on
filetype indent on
if has('nvim')
  set cursorline
endif

" search behavior
set incsearch " match as you type
set ignorecase " ignore case
set smartcase " ...except when your search is capitalized

" day/night coloring
set t_Co=256
set background=dark
" if strftime("%H") >= 5 && strftime("%H") < 18
"   set background=light
" else
"   set background=dark
" endif

" keep 2 lines above/below the cursor when scrolling
set scrolloff=8
set sidescrolloff=8

" shut the fuck up
" set visualbell " OUCH
set noerrorbells

" detect non-Vim file changes & read them into the buffer
set autoread

" status bar
set laststatus=2
set showmode
set showcmd

" rendering
set ttyfast

" autocompletion
set wildmenu
set wildmode=list:longest

" install plugins
call plug#begin()
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'ayu-theme/ayu-vim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'whonore/Coqtail'
call plug#end()

" colorscheme catppuccin-mocha

set termguicolors
let ayucolor="dark"
colorscheme ayu
