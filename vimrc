"
" Minimal ~/.vimrc by Marius Gedminas
" To get the full one, git clone https://gedmin.as/dotvim ~/.vim
"
if filereadable($HOME . "/.vim/vimrc")
  source $HOME/.vim/vimrc
else
  set nocp ai et sts=4 sw=4 bs=2 pt=<f11>
  set ls=2 ch=2 sc ru is fdls=99 hidden
  if v:version >= 704
    set fo+=j
    let &flp='^\s*\d\+[\]:.)}\t ]\s*'  " default value
    let &flp.='\|^\s*\(#\s\)\=[-*]\s*' " also recognize bulleted lists
  endif
  if exists("$LC_VIM_BACKGROUND")
    " vim has terminal background color detection, but it's unreliable
    " and also causes flashing, so I set a custom env var in my .bashrc to
    " force a specific vim background color.  The variable is called LC_xxx
    " so that ssh will forward it to remote machines.
    let &background = $LC_VIM_BACKGROUND
  endif
  syn enable
  filetype plugin indent on
  com! -range=% NukeTrailingWhitespace <line1>,<line2>s/\s\+$//
  " Alt-. inserts last word from previous line
  inoremap <Esc>. <C-R>=split(getline(line(".")-1))[-1]<CR>
  " make ^W/^U undoable separately, see :h ins-special-special
  inoremap <C-W> <C-G>u<C-W>
  inoremap <C-U> <C-G>u<C-U>
  " <C-Del> is so convenient
  inoremap <C-Del> <C-O>dw
  inoremap <C-Backspace> <C-O>db
  " <F2> means save is built into my muscle memory
  noremap <F2> :update<CR>
  imap <F2> <C-O><F2>
  " editing ~/.vimrc
  map ,e :e ~/.vimrc<CR>
  map ,s :source ~/.vimrc<CR>
  " editing files in the same directory
  map <expr> ,E ":e ".expand("%:h")."/"
  map <expr> ,R ":e ".expand("%:r")."."
  " insert line under cursor
  cnoremap <C-R><C-L> <C-R>=getline(".")<CR>
  " search for selected text
  vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
  vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>
  set pastetoggle=<F11>
  " :terminal conveniences
  if has("terminal")
    tnoremap <C-S-Up>     <C-W><Up>
    tnoremap <C-S-Down>   <C-W><Down>
    tnoremap <C-S-Left>   <C-W><Left>
    tnoremap <C-S-Right>  <C-W><Right>
    tnoremap <S-PageUp>   <C-W>N<PageUp>
    tnoremap <S-PageDown> <C-W>N<PageDown>
    tnoremap <C-W><Space> <C-W>.
  endif
  augroup VIMRC
    au!
    " :h last-position-jump
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &ft != 'gitcommit' | exe "normal g`\"" | endif
    " mkdir %:h on save
    au BufWritePre * if !isdirectory(expand("%:p:h")) | echomsg "Creating parent directory " . expand("%:h") | call mkdir(expand("%:p:h"), "p") | endif
    " autodetect filetype on save
    au BufWritePost * if &ft == "" | filetype detect | endif
    " chmod +x on save
    au BufWritePost * if getline(1) =~ "^#!" && expand("<afile>:t") !~ "test.*py" && expand("<afile>") !~ "://" | silent exec '!chmod +x <afile>' | endif
    " /root/Changelog
    au BufRead,BufNewFile /root/Changelog*,/root/**/Changelog* setlocal fo-=t fo+=rl et sw=2 sts=2 com=b:#,fb:-
    au BufRead,BufNewFile /root/Changelog*,/root/**/Changelog* setlocal fdm=indent fdi=
    au BufRead,BufNewFile /root/Changelog*,/root/**/Changelog* map <buffer> ,p :s/^\S\+@\S\+ \S\+ $\( sudo\)\= /  /<cr>
    au BufRead,BufNewFile /root/Changelog*,/root/**/Changelog* map <buffer> ,q :Quote<cr>
    au BufRead,BufNewFile /root/Changelog*,/root/**/Changelog* map <buffer> ,c :Comment<cr>
    au BufRead,BufNewFile /root/Changelog*,/root/**/Changelog* map <buffer> ,t :put ='    # ['.strftime('%H:%M').'] '<cr>A
  augroup END
  com! -range Quote setlocal et | <line1>,<line2> retab | <line1>,<line2> call s:quote("| ")
  com! -range Comment setlocal et | <line1>,<line2> retab | <line1>,<line2> call s:quote("# ")
  fun! s:quote(prefix)
    let saved = exists('*getcurpos') ? getcurpos() : getpos('.')
    let previous = getline(prevnonblank(line('.') - 1))
    let indent = matchstr(previous, '^\s*')
    if previous !~ '^\s*\([#|]\|\.\{3}\)'
      let indent .= "  "
    endif
    let line = getline('.')
    let new_line = indent . a:prefix . line
    call setline('.', substitute(new_line, '\s\+$', '', ''))
    call setpos('.', saved)
  endfun
endif
