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
set spellfile=~/.dotfiles/nvim/spell/en.utf-8.add
autocmd FileType markdown set spell spelllang=en_us
autocmd FileType markdown set foldexpr=NestedMarkdownFolds()
" inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u 
setlocal textwidth=80
setlocal wrapmargin=0

" Check word frequencies
function! WordFrequency() range
  let all = split(join(getline(a:firstline, a:lastline)), '\A\+')
  let frequencies = {}
  for word in all
    let frequencies[word] = get(frequencies, word, 0) + 1
  endfor
  new
  setlocal buftype=nofile bufhidden=hide noswapfile tabstop=20
  for [key,value] in items(frequencies)
    call append('$', key."\t".value)
  endfor
  sort i
endfunction
command! -range=% WordFrequency <line1>,<line2>call WordFrequency()

" Sorts numbers in ascending order.
" Examples:
" [2, 3, 1, 11, 2] --> [1, 2, 2, 3, 11]
" ['2', '1', '10','-1'] --> [-1, 1, 2, 10]
function! Sorted(list)
  " Make sure the list consists of numbers (and not strings)
  " This also ensures that the original list is not modified
  let nrs = ToNrs(a:list)
  let sortedList = sort(nrs, "NaturalOrder")
  echo sortedList
  return sortedList
endfunction

" Comparator function for natural ordering of numbers
function! NaturalOrder(firstNr, secondNr)
  if a:firstNr < a:secondNr
    return -1
  elseif a:firstNr > a:secondNr
    return 1
  else 
    return 0
  endif
endfunction

" Coerces every element of a list to a number. Returns a new list without
" modifying the original list.
function! ToNrs(list)
  let nrs = []
  for elem in a:list
    let nr = 0 + elem
    call add(nrs, nr)
  endfor
  return nrs
endfunction

function! WordFrequency() range
  " Words are separated by whitespace or punctuation characters
  let wordSeparators = '[[:blank:][:punct:]]\+'
  let allWords = split(join(getline(a:firstline, a:lastline)), wordSeparators)
  let wordToCount = {}
  for word in allWords
    let wordToCount[word] = get(wordToCount, word, 0) + 1
  endfor

  let countToWords = {}
  for [word,cnt] in items(wordToCount)
    let words = get(countToWords,cnt,"")
    " Append this word to the other words that occur as many times in the text
    let countToWords[cnt] = words . " " . word
  endfor

  " Create a new buffer to show the results in
  new
  setlocal buftype=nofile bufhidden=hide noswapfile tabstop=20

  " List of word counts in ascending order
  let sortedWordCounts = Sorted(keys(countToWords))

  call append("$", "count \t words")
  call append("$", "--------------------------")
  " Show the most frequent words first -> Descending order
  for cnt in reverse(sortedWordCounts)
    let words = countToWords[cnt]
    call append("$", cnt . "\t" . words)
  endfor
endfunction

command! -range=% WordFrequency <line1>,<line2>call WordFrequency()
" Statusline
" ---------------------------------------------------------
source ~/.config/nvim/statusline.vim

endif
