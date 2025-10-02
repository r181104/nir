" ===============================
"   Vim Settings - Transparent & Nord/Material
" ===============================
" --- Basic Settings ---
set nocompatible
syntax enable
filetype plugin indent on
set hidden
set ttyfast
set lazyredraw
set termguicolors
set showcmd
set showmatch
set signcolumn=yes
set virtualedit=block
set wrap
set linebreak
set number
set relativenumber
set cursorline
set cursorcolumn
set scrolloff=8
set sidescrolloff=8

" --- Tabs & Indentation ---
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set cindent
set autoindent

" --- Search ---
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan

" --- Swap & Undo ---
set noswapfile
set undofile
set undodir=~/.vim/undo

" --- Performance ---
set updatetime=50
set synmaxcol=500
set ttimeoutlen=10

" --- Leader Key ---
let mapleader=" "

" ===============================
"   Clipboard - Works Every Time
" ===============================
function! YankClipboard()
    let l:reg = getreg('"')
    if executable('wl-copy')
        call system('wl-copy', l:reg)
    elseif executable('xclip')
        call system('xclip -selection clipboard', l:reg)
    elseif executable('xsel')
        call system('xsel --clipboard --input', l:reg)
    else
        echo "No clipboard tool found"
    endif
endfunction

vnoremap <silent> <leader>y :<C-u>call YankClipboard()<CR>gv
nnoremap <silent> <leader>y :<C-u>call YankClipboard()<CR>

" ===============================
"   Keybindings
" ===============================
nnoremap <silent> <leader>h :nohl<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>? :echo "Space-w: Save\nSpace-q: Escape\nSpace-y: Yank\nSpace-t: Terminal\nSpace-l: Toggle list\nCtrl+hjkl: Window nav"<CR>

nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

nnoremap <leader>sv <C-w>v<C-w>l
nnoremap <leader>sh <C-w>s
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>

nnoremap <leader>t :terminal<CR>
tnoremap <Esc> <C-\><C-n>

nnoremap <leader>l :set list!<CR>

" ===============================
"   Comment Toggler
" ===============================
function! ToggleComment()
    let comment_map = {
                \ 'vim': '"', 'python': '#', 'sh': '#', 'nix': '#', 'zsh': '#',
                \ 'javascript': '//', 'typescript': '//', 'c': '//', 'cpp': '//',
                \ 'go': '//', 'lua': '--', 'sql': '--', 'ruby': '#', 'yaml': '#',
                \ 'conf': '#', 'fstab': '#', 'bash': '#', 'make': '#', 'cmake': '#'
                \}
    let comment = get(comment_map, &filetype, '#')
    let regex = '^\s*' . comment . '\s\?'
    let line = getline('.')
    if line =~ regex
        execute 's/' . regex . '//'
    else
        execute 's/^/' . comment . ' /'
    endif
endfunction

nnoremap gcc :call ToggleComment()<CR>
vnoremap gc :call ToggleComment()<CR>

" ===============================
"   Autocommands
" ===============================
augroup vimrc_autocmds
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
    autocmd BufWritePre * %s/\s\+$//e
    autocmd FileType python      setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType javascript  setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType typescript  setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType json        setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType html        setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType css         setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType scss        setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType yaml        setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType ruby        setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType java        setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType c           setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType cpp         setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType go          setlocal shiftwidth=4 tabstop=4 noexpandtab
    autocmd FileType rust        setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType lua         setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType sh          setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType zsh         setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType vue         setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType markdown    setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType conf        setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType nix         setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd BufNewFile,BufRead *.rc set filetype=conf
    autocmd BufNewFile,BufRead *.nix set filetype=nix
augroup END

" ===============================
"   Nord/Material Highlights - Transparent Background
" ===============================
hi Normal         guifg=#D8DEE9 guibg=NONE ctermbg=NONE
hi CursorLine     guibg=NONE ctermbg=NONE
hi CursorColumn   guibg=NONE ctermbg=NONE
hi Visual         guibg=#434C5E
hi Search         guibg=#81A1C1 guifg=#2E3440
hi IncSearch      guibg=#88C0D0 guifg=#2E3440
hi LineNr         guifg=#4C566A guibg=NONE
hi StatusLine     guifg=#ECEFF4 guibg=#3B4252
hi StatusLineMode guifg=#81A1C1 guibg=#3B4252 gui=bold
hi StatusLineInfo guifg=#88C0D0 guibg=#3B4252
hi StatusLineGit  guifg=#A3BE8C guibg=#3B4252 gui=italic
hi StatusLineWarning guifg=#EBCB8B guibg=#3B4252 gui=bold
hi Comment        guifg=#616E88 gui=italic guibg=NONE
hi Constant       guifg=#B48EAD guibg=NONE
hi Identifier     guifg=#8FBCBB guibg=NONE
hi Statement      guifg=#81A1C1 guibg=NONE
hi PreProc        guifg=#D08770 guibg=NONE
hi Type           guifg=#8FBCBB guibg=NONE
hi Special        guifg=#EBCB8B guibg=NONE
hi Underlined     guifg=#88C0D0 gui=underline guibg=NONE
hi Todo           guifg=#EBCB8B guibg=NONE gui=bold

" -------------------------------
" Remove left vertical line on number column (fixed properly)
" -------------------------------
set fillchars=vert:\ ,stl:\ ,stlnc:\ ,eob:\

" -------------------------------
" Map Esc to Ctrl-C
" -------------------------------
inoremap <Esc> <C-C>
vnoremap <Esc> <C-C>
cnoremap <Esc> <C-C>
tnoremap <Esc> <C-C>

" ===============================
"   Statusline
" ===============================
let g:currentmode = {
            \ 'n'  : ' NORMAL ',
            \ 'i'  : ' INSERT ',
            \ 'R'  : ' REPLACE ',
            \ 'v'  : ' VISUAL ',
            \ 'V'  : ' V-LINE ',
            \ 'x22': ' V-BLOCK ',
            \ 'c'  : ' COMMAND ',
            \ 't'  : ' TERMINAL '
            \}

function! FileSize()
    let bytes = getfsize(expand('%:p'))
    if bytes <= 0 | return '' | endif
    if bytes >= 1024 * 1024
        return printf('%.1f MB', bytes / (1024.0 * 1024))
    elseif bytes >= 1024
        return printf('%.1f KB', bytes / 1024.0)
    else
        return bytes . ' B'
    endif
endfunction

function! ReadOnly()
    return &readonly || !&modifiable ? '' : ''
endfunction

function! GitIndicator()
    if !empty(finddir('.git', ';'))
        return ' GIT'
    endif
    return ''
endfunction

set laststatus=2
set statusline=
set statusline+=%#StatusLineMode#
set statusline+=\ %{toupper(g:currentmode[mode()])}\
set statusline+=%#StatusLineInfo#
set statusline+=[%n]
set statusline+=\ %<%F
set statusline+=%#StatusLineWarning#
set statusline+=\ %{ReadOnly()}
set statusline+=\ %m
set statusline+=%*
set statusline+=%#StatusLineGit#
set statusline+=%=
set statusline+=\ %{GitIndicator()}
set statusline+=%#StatusLineInfo#
set statusline+=\ %y
set statusline+=\ %{(&fenc!=''?&fenc:&enc)}
set statusline+=\ [%{&ff}]
set statusline+=\ %{FileSize()}
set statusline+=%#StatusLineMode#
set statusline+=\ %3p%%
set statusline+=\ \ %4l:%-3c
set statusline+=\

" ===============================
"   Mouse
" ===============================
if has('mouse')
    set mouse=a
endif
