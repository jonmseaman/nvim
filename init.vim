call plug#begin()
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'djoshea/vim-autoread'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jceb/vim-orgmode'

Plug 'ryanoasis/vim-devicons'

" Theme
Plug 'morhetz/gruvbox'
call plug#end()

" General VIM improvements
:colorscheme gruvbox
set title
set go=a
" Allow mouse input
set mouse=a
" Use Windows Clipboard
set clipboard=unnamedplus
set ignorecase
" Keep a few lines on the top/bottom when scrolling.
set scrolloff=7

" Highlight current line
set cursorline
" Reminder to press enter key
set colorcolumn=81

" Some basics:
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber
set linebreak

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline
autocmd FileType * silent setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Auto reload files changed on disk if there is no save.
set autoread
" Ctrl+Backspace to delete words
imap <C-BS> <C-W>
" Escape should stop highlights
map <silent> <Esc> :nohlsearch<Enter>

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<Enter>

" Move selected lines while maintaining selection
" move selected lines up one line
xnoremap <A-k>  :m-2<CR>gv=gv
xnoremap <A-Up>  :m-2<CR>gv=gv
" move selected lines down one line
xnoremap <A-j>  :m'>+<CR>gv=gv
xnoremap <A-Down>  :m'>+<CR>gv=gv


" Use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" ## Windows
"
" shellslash makes the fzm preview panel work correctly.
" It also allows the VimwikiCheckLinks command to work.
" Disable this to run vim-plug
" shellslash breaks the NERDTree open command. There is
" apparently an unreleased fix to this issue, but I would
" need to build the thing myself and that would suck really bad.
if has("win32")
  " set shellslash
  " let $PATH = "C:\\Program Files\\Git\\usr\\bin;" . $PATH
endif

" Use the custom font with icons.
if has("win32")
    " Consolas:h12 gives emoji support.
    set guifont=Consolas:h12
endif

" Goyo plugin makes text more readable when writing prose:
    map <leader>f :Goyo \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
    map <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
    set splitbelow splitright

" Nerd tree
	map <leader>nn :NERDTreeToggle<Enter>
    map <leader>nf :NERDTreeFind<Enter>
    map <leader>nc :NERDTreeCWD<Enter>

    " Better tree bindings, same as vimwiki.
    " Unfortunately, these only work in GUI mode.
    let NERDTreeMapOpenVSplit='<C-Enter>'
    let NERDTreeMapOpenSplit='<S-Enter>'

	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks.md'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks.md'
    endif

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>~/Notes/bibliography.bib<CR>

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
 	let g:vimwiki_list = [
         \ {'path': '~/Notes', 'syntax': 'markdown', 'ext': '.md', 'diary_rel_path': 'Journal/'},
         \ {'path': '~/Notes/jonmseaman.github.io', 'syntax': 'markdown', 'ext': '.md'},
         \ {'path': '~/Notes/jonms.com', 'syntax': 'markdown', 'ext': '.md'},
         \ ]
    " Directory links should open index file
    let g:vimwiki_dir_link = 'index'
    let g:vimwiki_folding = 'expr'

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Used to fix links when using the auto suggest feature.
" Convert the current line's slashes from / to \ and vice versa.
nnoremap <silent> <Leader>/ :let tmp=@/<Bar>s:\\:/:ge<Bar>let @/=tmp<Bar>noh<CR>
nnoremap <silent> <Leader><Bslash> :let tmp=@/<Bar>s:/:\\:ge<Bar>let @/=tmp<Bar>noh<CR>

" Close all but the current buffer
command! BufOnly silent! execute "%bd|e#|bd#"

" Make NERDTree only show your notes.
" Pressing f in NERDTree toggles the hidden files.
let NERDTreeIgnore=['\(\.md\|\.org\|\.txt\)\@<!$[[file]]']

" Open CtrlP to the current working directory.
" I think the default is the original directory vim opened to.
let g:ctrlp_cmd = 'CtrlPCurWD'

" Make terminal easier to exit.
:tnoremap <Esc> <C-\><C-n>

" Make Quick Notes
" Opens quick notes and starts a new line at the end. It also moves the line
" you are working on to the top.
map <leader>qq :e ~/Notes/Quick Notes.org<CR>Go<CR><CR>**<space><Esc>zt<S-a>
set foldlevel=3

" Make neovide look nice. Add fullscreen hotkey.
" Reference: https://neovide.dev/command-line-reference.html
if exists("g:neovide")
    " Allow Neovide Fullscreen
    function Neovide_fullscreen()
        if g:neovide_fullscreen == v:true
            let g:neovide_fullscreen=v:false
        else
            let g:neovide_fullscreen=v:true
        endif
    endfunction
    map <F11> :call Neovide_fullscreen()<cr>

    let g:neovide_transparency=0.85
    let g:neovide_remember_window_size=v:false
endif
