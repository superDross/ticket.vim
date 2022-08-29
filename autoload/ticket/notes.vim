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


function! ticket#notes#GrepNotesFzf(args)
  " interactively search notes contents using junegunn/fzf.vim
  if has('nvim')
    echoerr 'GrepTicketNotesFzf only works with vim'
  endif
  " NOTE: this is a little hacky, if they change this var name in fzf repo
  " this will always echoerr
  if !get(g:, 'loaded_fzf_vim', 0)
    echoerr 'junegunn/fzf.vim is not loaded or installed'
  endif
  call fzf#vim#grep(
  \   'rg --type md --column --line-number --no-heading --color=always --smart-case -- '.shellescape(a:args), 1,
  \   fzf#vim#with_preview({'dir': g:session_directory}))
endfunction
