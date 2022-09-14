" Sessions.vim
"
" High level functions for creating, opening and getting sessions


function! ticket#sessions#CreateSession()
  " creates or overwrites the session file associated with the git branch or
  " directory name in the working directory
  let sessionfile = ticket#files#GetSessionFilePath('.vim')
  execute 'mksession! ' . sessionfile
endfunction


function! ticket#sessions#OpenSession()
  " opens the session file associated with the git branch or directory name in
  " the working directory
  let sessionfile = ticket#files#GetSessionFilePathOnlyIfExists('.vim')
  execute 'source ' . sessionfile
endfunction


function! ticket#sessions#GetAllSessionNames(repo)
  " returns all session names stripped of feature/bugfix prefix & extension
  " for a given repo
  let files = globpath(g:session_directory . '/' . a:repo, '*.vim', 0, 1)
  return map(files, "fnamemodify(v:val, ':t:r')")
endfunction
