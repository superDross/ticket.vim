" ticket.vim - Session
" Author:      David Ross <https://github.com/superDross/>


if exists('g:auto_ticket') ==# 0
  let g:auto_ticket = 0
endif


if exists('g:ticket_black_list') ==# 0
  let g:ticket_black_list = []
endif


if exists('g:default_session_name') ==# 0
  let g:default_session_name = 'main'
endif


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


function! CheckIfGitRepo()
  " returns 1 if working directory is a git repository, otherwise returns 0
  let msg = system('git log')
  try
    if matchstr(msg, '.*not a git repository.*') ==# msg
      throw 'not a repo'
    elseif matchstr(msg, '.*does not have any commits yet.*') ==# msg
      throw 'no commits'
    else
      return 1
    endif
  catch /.*not a repo/
    return 0
  catch /.*no commits/
    echoerr 'Make an initial branch commit before saving a session'
  endtry
endfunction


function! GetRepoName()
  " returns remote name if set, otherwise top directory name is returned
  if system('git config --get remote.origin.url') !=# ''
    return system('basename -s .git `git config --get remote.origin.url` | tr -d "\n"')
  else
    return system('basename `git rev-parse --show-toplevel` | tr -d "\n"')
  endif
endfunction


function! GetBranchName()
  " returns the branch name checked out in the current working directory
  return system('git symbolic-ref --short HEAD | tr "/" "\n" | tail -n 1 | tr -d "\n"')
endfunction


function! GetSessionDirPath()
  " returns and creates the directory path for a session file.
  " uses the git branch name in the current workind dir or the dirname
  " as the basename for the directory.
  let name = CheckIfGitRepo() == 1 ? GetRepoName() : system('basename $(pwd) | tr -d "\n"')
  let dirpath = '~/.tickets/' . name
  call system('mkdir -p ' . dirpath)
  return dirpath
endfunction


function! BranchInBlackList()
  " determines if the branch name in the working directory is within the user
  " defined black list
  let branchname = GetBranchName()
  if (index(g:ticket_black_list, branchname) >= 0)
    return 1
  endif
  return 0
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


function! CreateSession()
  " creates or overwrites the session file associated with the git branch or
  " directory name in the working directory
  let sessionfile = GetSessionFilePath('.vim')
  execute 'mksession! ' . sessionfile
endfunction


function! OpenSession()
  " opens the session file associated with the git branch or directory name in
  " the working directory
  let sessionfile = GetSessionFilePathOnlyIfExists('.vim')
  execute 'source ' . sessionfile
endfunction


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
  let ticketsdir = expand('~') . '/.tickets/**/*.md'
  execute 'vimgrep! /\c' . a:query . '/j ' . ticketsdir
endfunction


function! GetAllBranchNames()
  " returns a list of all branch names (stripped of feature/bugfix prefix)
  " associated within the current repo
  return split(
  \ system(
  \    "git for-each-ref --format='%(refname:short)' refs/heads | sed 's@.*/@@'"
  \ )
  \)
endfunction


function! GetAllSessionNames(repo)
  " returns all session names stripped of feature/bugfix prefix & extension
  " for a given repo
  return split(system(
  \  'find ~/.tickets/' . a:repo . ' -type f -name "*.vim" |
  \   xargs -I {} basename {} |
  \   sed "s/.\{4\}$//"'
  \))
endfunction


function DeleteOldSessions(force_input)
  " removes sessions files that no longer have local branches
  " only works within directories that are git repositories
  if CheckIfGitRepo() == 0
      throw 'Sessions can only be deleted within a git repository.'
  endif
	
  let branches = GetAllBranchNames()
  let repo = GetRepoName()

  let deletelist = []
  for session in GetAllSessionNames(repo)
    if index(branches, session) == -1  " if session not in branches
      let sessionpath = system(
      \  'find ~/.tickets/' . repo . ' -type f -name ' . '*' . session . '.vim'
      \)
      call add(deletelist, sessionpath)
    endif
  endfor

  echo join(deletelist, "\r")
  if a:force_input == 1
    let answer = 'y'
  else
    let answer = input('Are you sure you want to delete the above session files? (y/n): ')
  endif

  if answer ==# 'y'
    for file in deletelist
      " TODO: find out why delete() does not work here
      call system('rm ' . file)
    endfor
  endif

endfunction


function! DetermineAuto()
  " determines whether we auto save/open or not open file opening
  if g:auto_ticket
    " only autosave if file is in a valid git repo
    try
      call CheckIfGitRepo()
    catch /.*/
      return 0
    endtry
    " only autosave if the current branch is not black listed
    if BranchInBlackList() ==# 1
      return 0
    endif

    return 1
  endif
endfunction


augroup ticket
  " automatically open and save sessions
  if DetermineAuto()
    let session_file_path = GetSessionFilePath('.vim')
    if filereadable(expand(session_file_path))
      autocmd VimEnter * :if argc() ==# 0 | call OpenSession() | endif
    else
      call CreateSession()
    endif
    autocmd VimLeavePre,BufWritePost * :call CreateSession()
  endif
augroup END


command! SaveSession :call CreateSession()
command! OpenSession :call OpenSession()
command! CleanupSessions :call DeleteOldSessions(0)
command! SaveNote :call CreateNote()
command! OpenNote :call OpenNote()
command! -nargs=1 GrepNotes :call GrepNotes(<f-args>)
command! -bang -nargs=* GrepTicketNotesFzf
  \ call fzf#vim#grep(
  \   'rg --type md --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'dir': '~/.tickets/'}), <bang>0)
