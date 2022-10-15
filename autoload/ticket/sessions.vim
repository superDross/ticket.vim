" Sessions.vim
"
" High level functions for creating, opening and getting sessions


function! ticket#sessions#CreateSession() abort
  " creates or overwrites the session file associated with the git branch or
  " directory name in the working directory
  let sessionfile = ticket#files#GetSessionFilePath('.vim')
  execute 'silent mksession! ' . sessionfile
  call ticket#utils#VeryVerbosePrint('Session Saved: ' . sessionfile)
endfunction


function! ticket#sessions#OpenSession() abort
  " opens the session file associated with the git branch or directory name in
  " the working directory
  let sessionfile = ticket#files#GetSessionFilePathOnlyIfExists('.vim')
  execute 'silent source ' . sessionfile
  call ticket#utils#VeryVerbosePrint('Session Opened: ' . sessionfile)
endfunction


function! ticket#sessions#GetAllSessionNames(repo) abort
  " returns all session names stripped of feature/bugfix prefix & extension
  " for a given repo
  let files = globpath(g:session_directory . '/' . a:repo, '*.vim', 0, 1)
  return map(files, "fnamemodify(v:val, ':t:r')")
endfunction


function! ticket#sessions#FindSessions(query) abort
  " returns all notes file paths that contain the given query
  " TODO: find away to create a custom mapping for quickfix
  "       https://vi.stackexchange.com/questions/21254/visual-delete-items-from-quickfix-list
  "       /after/ftplugin/qf.vim could work but applies to all
  "       quickfix lists
  let ticketsdir = g:session_directory . '/**/*.vim'
  execute 'vimgrep! /\c' . a:query . '/j ' . ticketsdir
  copen
endfunction
