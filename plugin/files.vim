" Files.vim
"
" Functions for constructing and getting session and note files/directories


function! GetRootTicketDir(legacy_dir)
  " determines root directory to store all session and notes files within.
  " we follow the XDG specification unless an legacy directory already exists
  " in which case we return it.
  if $XDG_DATA_HOME != ''
    return $XDG_DATA_HOME . '/tickets-vim'
  elseif isdirectory(expand(a:legacy_dir))
    return expand(a:legacy_dir)
  else
    call system('mkdir -p ~/.local/share')
    return expand('~/.local/share/tickets-vim')
  endif
endfunction


function! CheckFileExists(file)
  " checks if parsed file path exists otherwise raises an error
  try
    if filereadable(expand(a:file))
      return a:file
    else
      throw 'no file'
    endif
  catch /.*no file/
    echoerr 'File ' . a:file . ' does not exist'
  endtry
endfunction


function! GetSessionDirPath()
  " returns and creates the directory path for a session file.
  " uses the git branch name in the current working dir or the dirname
  " as the basename for the directory.
  let name = CheckIfGitRepo() == 1 ? GetRepoName() : system('basename $(pwd) | tr -d "\n"')
  let dirpath = g:session_directory . '/' . name
  call system('mkdir -p ' . dirpath)
  return dirpath
endfunction


function! GetSessionFilePath(extension)
  " creates a filepath to the session.
  " this is determined by the git branch in the working directory or by the
  " directory name (if not git repo) and the given extension.
  let branchname = CheckIfGitRepo() == 1 ? GetBranchName() : g:default_session_name
  let dirpath = GetSessionDirPath()
  return dirpath . '/' . branchname . a:extension
endfunction


function! GetSessionFilePathOnlyIfExists(extension)
  " returns the session filepath only if it exists within .ticket directory
  let filepath = GetSessionFilePath(a:extension)
  call CheckFileExists(filepath)
  return filepath
endfunction


function GetSessionsWithoutBranches()
  " return a list of session files associated with the current working
  " directory that do not have local branches
  let branches = GetAllBranchNames()
  let repo = GetRepoName()

  let session_list = []
  for session in GetAllSessionNames(repo)
    if index(branches, session) == -1  " if session not in branches
      let sessionpath = system(
      \  'find ' . g:session_directory . '/' . repo . ' -type f -name ' . '*' . session . '.vim'
      \)
      call add(session_list, sessionpath)
    endif
  endfor
  
  return session_list
endfunction
