" Notes.vim
"
" High level functions for creating, opening and getting notes


function! CreateNote()
  " creates or overwrites the note file associated with the git branch or
  " directory name in the working directory
  let mdfile = GetSessionFilePath('.md')
  execute 'w ' . mdfile
endfunction


function! OpenNote()
  " opens the note file associated with the git branch or directory name in
  " the working directory
  let mdfile = GetSessionFilePath('.md')
  execute 'e ' . mdfile
endfunction


function! GrepNotes(query)
  " returns all notes file paths that contain the given query
  let ticketsdir = g:session_directory . '/**/*.md'
  execute 'vimgrep! /\c' . a:query . '/j ' . ticketsdir
endfunction
