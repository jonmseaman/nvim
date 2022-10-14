" Install vim-plug automatically
" if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
" 	echo "Downloading junegunn/vim-plug to manage plugins..."
" 	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
" 	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
" 	autocmd VimEnter * PlugInstall
" endif


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
Plug 'axvr/org.vim'

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
set scrolloff=7

" Highlight current line
set cursorline
" Reminder to press enter key
set colorcolumn=81

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

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
" set fileformat=dos
"
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

" Replace ex mode with gq " TODO: Why would I want this?
	"map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
 	let g:vimwiki_list = [
         \ {'path': '~/Workspace/Notes', 'syntax': 'markdown', 'ext': '.md', 'diary_rel_path': 'Journal/'},
         \ {'path': '~/Workspace/Notes/jonmseaman.github.io', 'syntax': 'markdown', 'ext': '.md'},
         \ {'path': '~/Workspace/Notes/jonms.com', 'syntax': 'markdown', 'ext': '.md'},
         \ ]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex
    " Directory links should open index file
    let g:vimwiki_dir_link = 'index'
    let g:vimwiki_folding = 'expr'

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif


" Used to fix links when using the auto suggest featuer.
nnoremap <silent> <Leader>/ :let tmp=@/<Bar>s:\\:/:ge<Bar>let @/=tmp<Bar>noh<CR>
nnoremap <silent> <Leader><Bslash> :let tmp=@/<Bar>s:/:\\:ge<Bar>let @/=tmp<Bar>noh<CR>

" Close all but the current buffer
command! BufOnly silent! execute "%bd|e#|bd#"

silent cd ~/Workspace/Notes
" Get started and open vimwiki
function! SetupDefaultWorkspace()
    NERDTreeCWD
    wincmd l
    VimwikiIndex
endfunction
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") |  call SetupDefaultWorkspace() | endif

" Make NERDTree only show your notes.
let NERDTreeIgnore=['\(\.md\|\.org\|\.txt\)\@<!$[[file]]']

" Open CtrlP to the current working directory.
" I think the default is the original directory vim opened to.
let g:ctrlp_cmd = 'CtrlPCurWD'

" Make terminal easier to exit.
:tnoremap <Esc> <C-\><C-n>

" Make Quick Notes
" Opens quick notes and starts a new line at the end. It also moves the line
" you are working on to the top.
map <leader>qq :e ~/Workspace/Notes/0_JonathansNotebook/Quick Notes.md<CR>Go<CR><CR>##<space><Esc>zt<S-a>
map <leader>qp :e ~/Workspace/Notes/1_Projects/index.md<CR>
map <leader>qb :e ~/Workspace/Notes/2_Backlog/index.md<CR>
set foldlevel=1

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
