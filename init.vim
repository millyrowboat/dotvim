"============================================================================"
"  
"  N       E       O                                      V       I      M
"
"============================================================================"
"  Forked with love from Steve Occhipinti (github.com/stevenocchipinti)
"  https://github.com/millyrowboat/dotvim                            "
"============================================================================"

call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/matchit.zip'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" Technology specific plugins
Plug 'w0rp/ale'
Plug 'prettier/vim-prettier'
Plug 'wincent/terminus'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'rainglow/vim'
Plug 'ryanoasis/vim-devicons'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           STANDARD VIM SETTINGS                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ts=2 sw=2           " Use 4 spaces for tabs
set expandtab           " Use spaces instead of tab characters
set nowrap              " (Dont) Wrap the display lines (not actual text)
set nu                  " Show line numbers
set splitright          " Open vertical splits on the right
set splitbelow          " Open the horizontal split below
set ruler               " Show row and column in status bar
set showcmd             " Show partial commands (such as 'd' when typing 'dw')
set ignorecase          " Case insensitive search by default
set smartcase           " Use case sensitive search in a capital letter is used
set nohlsearch          " Don't highlight searches, useful for jumping around
set scrolloff=3         " Number of lines to always show at at the top & bottom
set colorcolumn=81,91   " Highlight the 81st column (shorthand = :set cc=81)
set cursorline          " Highlight the line which the cursor is on
set nojoinspaces        " Use 1 space after "." when joining lines instead of 2
set shiftround          " Indent to the closest shiftwidth
set secure              " Make sure those project .vimrc's are safe
set list                " Show `listchars` characters
set listchars=tab:├─,trail:·
set showbreak=⤿
set hlsearch            " Search highlighting
set number
set linespace=3
set termguicolors

" Make vim remember undos, even when the file is closed!
set undofile            " Save undo's after file closes
set undodir=~/.vim/undo " where to save undo histories
set undolevels=1000     " How many undos
set undoreload=10000    " number of lines to save for undo

" COLOR!
colorscheme onedark


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     NEOVIM SPECIFIC (mostly bugfixes)                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


if has("nvim")
  " Live search and replace!
  set inccommand=nosplit

  " Use pipe in insert-mode and a block in normal-mode
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

  " BUG: netrw is really slow
  " No workaround yet except to use another file explorer

  " BUG: ctrl-l doesn't repaint the screen when its messed up by resizing
  " Temp workaround for <C-l> -- https://github.com/neovim/neovim/issues/3929
  map <C-l> :mode

  " BUG: Interactive shell commands don't work with the terminal anymore
  " Temp workaround for :W -- https://github.com/neovim/neovim/issues/1716
  command! W w !sudo -n tee % > /dev/null || echo "Press <leader>w to authenticate and try again"
  map <leader>w :new:term sudo true

else
  " To use different cursor modes in iTerm2
  " Ref: http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"

  " When you dont have write access, :W will write with sudo
  " Without this, you could use ':w !sudo tee %'
  command! W w !sudo tee % > /dev/null

endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                          CUSTOM VIM FUNCTIONALITY                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcut for spellcheck
map <leader>z :set spellz=
map <leader>Z :set nospell


" :Q is an accidental error for :q
cnoreabbrev Q q

" Set ts and sw
function! ToggleTS()
    if &l:sw == 2
        set ts=4 sw=4
    else
        set ts=2 sw=2
    endif

    echo "Set to " . &l:sw
    let g:airline_section_y='Spaces: ' . &l:sw
    :AirlineRefresh
endfunction

map <leader>2 :call ToggleTS()<CR>

" Q is another common accidental error to launch :ex mode - which I don't use
nnoremap Q <nop>


" Easier way to copy and paste from the global clipboard
map <leader>p "+p
map <leader>y "+y
" Y should act like C and D!
map Y y$


" Easier duplication
"map <leader>' <S-Y>

" Easier way to make a blank line but not go into insert mode
map <leader>o o
map <leader>O O

" Easier way to toggle highlighted search
map <leader>h :set hls!<bar>set hls?

" Easily move between windows with Ctrl-hjkl
set splitbelow
set splitright
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Keeps highlighting on till you turn it off with ,/
nmap <silent> ,/ :nohlsearch<CR>

" insert a new line at the end of the file using leader A
map <leader>A Go

" Move cursor to matched string when searching
set incsearch

" Shortcuts for debugging
autocmd FileType javascript map <leader>d odebugger;
autocmd FileType javascript map <leader>D Odebugger;
autocmd BufEnter *.rb,*.js syn match error contained "\<debugger\>"


" Filetype specific
au BufRead,BufNewFile *.sbt set filetype=scala
autocmd BufNewFile,BufRead *.markdown,*.textile setlocal filetype=octopress
autocmd FileType octopress,markdown map <leader>= yyp:s/./=/g
autocmd FileType octopress,markdown map <leader>- yyp:s/./-/g
autocmd FileType octopress,markdown,gitcommit setlocal spell
autocmd FileType octopress,markdown,gitcommit setlocal textwidth=80
autocmd BufRead,BufNewFile *.njk set filetype=html


" Set a nicer foldtext function
set foldtext=MinimalFoldText()
function! MinimalFoldText()
  let line = getline(v:foldstart)
  let n = v:foldend - v:foldstart + 1
  set fillchars=fold:\ 
  return line . " ⏎ " . n
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       CUSTOM EXTERNAL FUNCTIONALITY                          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Format JSON - filter the file through Python to format it
map =j :%!python -m json.tool

" Remove un-needed whitespace
map <silent> =w :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            PLUGIN CONFIGURATION                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" NETRW (builtin plugin)
let g:netrw_banner=0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\(^\|\s\s\)ntuser\.\S\+'
autocmd FileType netrw set nolist


" NERDTREE PLUGIN - (mnemonic: Files)
nmap <leader>f :NERDTreeToggle
nmap <leader>F :NERDTreeFind

" nerdtree - show dotfiles
let NERDTreeShowHidden=1
let NERDTreeIgnore=['^\..*\.swp$', '\~$']

" ALE Plugin

let g:ale_linters = {
\  'javascript': ['eslint', 'flow', 'prettier']
\}

" Use eslint to fix JS errors
let g:ale_fixers = {
\   'javascript': ['prettier']
\}

" " Fix files automatically on save
let g:ale_fix_on_save = 1

" Prettier config globals
let g:ale_javascript_prettier_options = '--no-semi true --arrow-parens always'

" VIM-JSX
let g:jsx_ext_required = 0

" VIM-JAVASCRIPT
let g:javascript_plugin_flow = 1


" VIM-CSS3-SYNTAX
augroup VimCSS3Syntax
  autocmd!
  autocmd FileType css,javascript.jsx setlocal iskeyword+=-
augroup END


" AIRLINE
let g:airline_left_sep=''
let g:airline_right_sep=''


" STARTIFT
let g:startify_session_persistence = 1

"" fzf
" Use ripgrep instead of default find command to traverse file system while respecting .gitignore
let $FZF_DEFAULT_COMMAND = '
  \ rg --column --line-number --files --no-ignore --hidden --follow
  \ --glob "!{.git,node_moduels}/*" '
" --column            : show column numbers
" --line-number       : show line numbers
" --files             : search each file that would be searched (but don't search)
" --hidden            : search hidden files and directories
" --follow            : follow symlinks
" --glob:   include or exclude files for searching that match the specified glob

" Map Ctrl P to :Files
nnoremap <silent> <C-P> :Files<CR> 

" Prettier
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue Prettier
let g:prettier#config#tab_width = 2
"
"
"COC
source $HOME/.config/nvim/coc.vim

" MARKDOWN PREVIEW 

nmap <C-m> <Plug>MarkdownPreview

