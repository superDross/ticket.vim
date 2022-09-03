" Notes.vim
"
" High level functions for creating, opening and getting notes


function! ticket#notes#CreateNote()
  " creates or overwrites the note file associated with the git branch or
  " directory name in the working directory
  let mdfile = ticket#files#GetSessionFilePath('.md')
  execute 'w ' . mdfile
endfunction


function! ticket#notes#OpenNote()
  " opens the note file associated with the git branch or directory name in
  " the working directory
  let mdfile = ticket#files#GetSessionFilePath('.md')
  execute 'e ' . mdfile
endfunction


function! ticket#notes#GrepNotes(query)
  " returns all notes file paths that contain the given query
  let ticketsdir = g:session_directory . '/**/*.md'
  execute 'vimgrep! /\c' . a:query . '/j ' . ticketsdir
endfunction


function! ticket#notes#GrepNotesFzfLua(args = '')
  " interactiely search notes contents using fzf-lua
  if ticket#utils#IsInstalled('fzf-lua')
    lua require('fzf-lua').grep({
      \ rg_glob=true,
      \ cwd = vim.g.session_directory,
      \ search=vim.fn.eval('a:args') .. ' -- *.md',
      \ no_esc=true
    \ })
    return
  else
    echoerr 'ibhagwan/fzf-lua is not loaded or installed'
  endif
endfunction


function! ticket#notes#GrepNotesFzfVim(args)
  " interactiely search notes contents using fzf.vim
  if ticket#utils#IsInstalled('fzf.vim')
    call fzf#vim#grep(
    \   'rg --type md --column --line-number --no-heading --color=always --smart-case -- '.shellescape(a:args), 1,
    \   fzf#vim#with_preview({'dir': g:session_directory}))
  else
    echoerr 'junegunn/fzf.vim is not loaded or installed'
  endif
endfunction


function! ticket#notes#GrepNotesFzf(args)
  " interactively search notes contents using junegunn/fzf.vim or fzf-lua
  if has('nvim')
    return ticket#notes#GrepNotesFzfLua(a:args)
  endif
  return ticket#notes#GrepNotesFzfVim(a:args)
endfunction
