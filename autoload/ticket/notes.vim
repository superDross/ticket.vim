" Notes.vim
"
" High level functions for creating, opening and getting notes


function! ticket#notes#CreateNote() abort
  " creates or overwrites the note file associated with the git branch or
  " directory name in the working directory
  let mdfile = ticket#files#GetSessionFilePath('.md')
  execute 'silent write! ' . mdfile
  call ticket#utils#VeryVerbosePrint('Note Saved: ' . mdfile)
endfunction


function! ticket#notes#OpenNote() abort
  " opens the note file associated with the git branch or directory name in
  " the working directory
  let mdfile = ticket#files#GetSessionFilePath('.md')
  execute 'silent edit ' . mdfile
  call ticket#utils#VeryVerbosePrint('Note Opened: ' . mdfile)
endfunction


function! ticket#notes#GrepNotes(query) abort
  " returns all notes file paths that contain the given query
  let ticketsdir = g:session_directory . '/**/*.md'
  execute 'vimgrep! /\c' . a:query . '/j ' . ticketsdir
  copen
endfunction
