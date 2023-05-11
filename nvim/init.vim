" ///////////////////////////////////////////////////////////
"
"     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
"     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
"     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
"     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
"     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
"     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
"                 ~/.config/nvim/init.vim
"              https://github.com/timmybytes
" //////////////////////////////////////////////////////////

" ---------------------------------------------------------
" VimPlug - Plugin Manager
" ---------------------------------------------------------

call plug#begin()

" Themes
" ---------------------------------------------------------
" Theme inspired by - https://github.com/Who23/dots
Plug 'drewtempelmeyer/palenight.vim'
" Usage: colorscheme palenight
Plug 'sainnhe/vim-color-forest-night' " e.g., 'forest-night'
" Usage: colorscheme forest-night
Plug 'franbach/miramare'
" Usage: colorscheme miramare - DEFAULT
Plug 'catppuccin/nvim', { 'branch': 'main', 'as': 'catppuccin' }

" Enhancements
" ---------------------------------------------------------
Plug 'chrisbra/Colorizer'
" Usage: ':h Colorizer'
Plug 'junegunn/goyo.vim'
" Usage: ':Goyo'

Plug 'junegunn/limelight.vim'
" Usage: ':Limelight' (works best with Goyo enabled)

Plug 'ryanoasis/vim-devicons'
" Usage: Enabled by default with compatible nerd fonts

Plug 'Yggdroot/indentLine'
" Usage: 'let g:indentLine_setColors = 0'
" Usage: 'let g:indentLine_char = '│''

Plug 'preservim/nerdtree'
" Usage: ':NERDTree'

Plug 'airblade/vim-gitgutter'

Plug 'justinmk/vim-sneak'
" Usage: ':s{char}{char}' Search for next instances of chars
" Usage: ':``' Go back to start

" Comfort
" ---------------------------------------------------------
" Plug 'tpope/vim-sleuth'
" Usage:
Plug 'tpope/vim-commentary'
" Usage: ':gcc' - Comment/Uncomment line

" Languages
" ---------------------------------------------------------
Plug 'sheerun/vim-polyglot'
Plug 'tmhedberg/SimpylFold'
Plug 'masukomi/vim-markdown-folding'

call plug#end()


" ---------------------------------------------------------
" General
" ---------------------------------------------------------

set nocompatible
syntax on
syntax enable
set termguicolors

let g:miramare_enable_italic = 1
colorscheme catppuccin
set nowrap
set noshowmode
set autoindent
set nonumber
set mouse=a
set number
set numberwidth=6

" Highlight search results
set hlsearch
" Press F4 to toggle highlighting on/off, and show current value.
:noremap <C-Bslash> :set hlsearch! hlsearch?<CR>
" Seach is case-insensitive
set ignorecase
augroup myautocommands
  " au commands - keep these grouped for performance
  autocmd FileType markdown set spell spelllang=en_us
  autocmd FileType markdown set foldexpr=NestedMarkdownFolds()
  " Go to last cursor position in file on reopening
augroup end

  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  endif


" Coding
" ---------------------------------------------------------
" Two spaces for tabs everywhere
set expandtab shiftwidth=2 tabstop=2
set foldenable
set foldmethod=syntax
set foldlevel=99

let NERDTreeShowHidden=1

let g:indentLine_setColors = 0
let g:indentLine_char = '│'

" Auto reload changed files
set autoread

set scrolloff=5
" Leave 5 lines of buffer when scrolling
set sidescrolloff=10
" Leave 10 characters of horizontal buffer when scrolling

" Writing/Prose
" ---------------------------------------------------------
set spellfile=~/.dotfiles/nvim/spell/en.utf-8.add
" inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
setlocal textwidth=80
setlocal wrapmargin=0

" TODO: Broken
" Statusline
" ---------------------------------------------------------
" source ~/.config/nvim/statusline.vim
