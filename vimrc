"
" Minimal ~/.vimrc by Marius Gedminas
" To get the full one, git clone https://gedmin.as/dotvim ~/.vim
"
if filereadable($HOME . "/.vim/vimrc")
  source $HOME/.vim/vimrc
else
  set nocp ai et sts=4 sw=4 bs=2
  set ls=2 ch=2 sc ru
  if v:version >= 704
    set fo+=j
  endif
  syn enable
  filetype plugin indent on
  com! -range=% NukeTrailingWhitespace <line1>,<line2>s/\s\+$//
  " Alt-. inserts last word from previous line
  inoremap <Esc>. <C-R>=split(getline(line(".")-1))[-1]<CR>
  " make ^W/^U undoable separately, see :h ins-special-special
  inoremap <C-W> <C-G>u<C-W>
  inoremap <C-U> <C-G>u<C-U>
  " editing ~/.vimrc
  map ,e :e ~/.vimrc<CR>
  map ,s :source ~/.vimrc<CR>
  " editing files in the same directory
  map <expr> ,E ":e ".expand("%:h")."/"
  map <expr> ,R ":e ".expand("%:r")."."
  " insert line under cursor
  cnoremap <C-R><C-L> <C-R>=getline(".")<CR>
  set pastetoggle=<F11>
  augroup VIMRC
    au!
    " :h last-position-jump
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &ft != 'gitcommit' | exe "normal g`\"" | endif
    " mkdir %:h on save
    au BufWritePre * if !isdirectory(expand("%:p:h")) | echomsg "Creating parent directory " . expand("%:h") | call mkdir(expand("%:p:h"), "p") | endif
    " autodetect filetype on save
    au BufWritePost * if &ft == "" | filetype detect | endif
    " chmod +x on save
    au BufWritePost * if getline(1) =~ "^#!" && expand("%:t") !~ "test.*py" && expand("%") !~ "://" | silent exec '!chmod +x <afile>' | endif
    " /root/Changelog
    au BufRead,BufNewFile /root/Changelog* setlocal fo-=t fo+=rl
    au BufRead,BufNewFile /root/Changelog* map <buffer> ,q :Quote<cr>
  augroup END
  com! -range Quote <line1>,<line2> call s:quote()
  fun! s:quote()
    let saved = getcurpos()
    let previous = getline(prevnonblank(line('.') - 1))
    let indent = matchstr(previous, '^\s*')
    if previous !~ '^\s*\([#|]\|\.\{3}\)'
      let indent .= "  "
    endif
    let line = getline('.')
    let new_line = indent . '| ' . line
    call setline('.', substitute(new_line, '\s\+$', '', ''))
    call setpos('.', saved)
  endfun
endif