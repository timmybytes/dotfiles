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

" VS Code Neovim Extension compatibility
if !exists('g:vscode')

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

" Enhancements
" ---------------------------------------------------------
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

" Comfort
" ---------------------------------------------------------
Plug 'tpope/vim-sleuth'
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
set termguicolors
colorscheme miramare
set nowrap
set noshowmode
set autoindent
set nonumber
set mouse=a
set number
set numberwidth=6

" Highlight search results
set hlsearch

" Go to last cursor position in file on reopening
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Coding
" ---------------------------------------------------------
set foldenable
set foldmethod=syntax
set foldlevel=99
let NERDTreeShowHidden=1

let g:indentLine_setColors = 0
let g:indentLine_char = '│'

" Writing/Prose
" ---------------------------------------------------------
autocmd FileType markdown set spell spelllang=en_us
autocmd FileType markdown set foldexpr=NestedMarkdownFolds()
" inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u 
setlocal textwidth=80
setlocal wrapmargin=0

" Statusline
" ---------------------------------------------------------
source ~/.config/nvim/statusline.vim

endif
