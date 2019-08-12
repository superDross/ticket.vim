" ticket.vim - Ticket
" Author:      David Ross <https://github.com/superDross/>
" Version:     0.1


function! CheckFileExists(file)
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
  let msg = system('git log')
  try
    if matchstr(msg, '.*not a git repository.*') ==# msg
      throw 'not a repo'
    elseif matchstr(msg, '.*does not have any commits yet.*') ==# msg
      throw 'no commits'
    endif
  catch /.*not a repo/
    echoerr 'The current directory is not a git repository'
  catch /.*no commits/
    echoerr 'Make an initial branch commit before saving a session'
  endtry
endfunction


function! GetRepoName()
  return system('basename -s .git `git config --get remote.origin.url` | tr -d "\n"')
endfunction


function! GetBranchName()
  return system('git symbolic-ref --short HEAD | tr "/" "\n" | tail -n 1 | tr -d "\n"')
endfunction


function! GetDirPath()
  let dirpath = '~/.tickets/' . GetRepoName()
  call system('mkdir -p ' . dirpath)
  return dirpath
endfunction


function! GetFilePath(extension)
  call CheckIfGitRepo()
  let branchname = GetBranchName()
  let dirpath = GetDirPath()
  return dirpath . '/' . branchname . a:extension
endfunction


function! CreateSession()
  let sessionfile = GetFilePath('.vim')
  execute 'mksession! ' . sessionfile
endfunction


function! OpenSession()
  let sessionfile = GetFilePath('.vim')
  call CheckFileExists(sessionfile)
  execute 'source ' . sessionfile
endfunction


function! CreateNote()
  let mdfile = GetFilePath('.md')
  execute 'w ' . mdfile
endfunction


function! OpenNote()
  let mdfile = GetFilePath('.md')
  call CheckFileExists(mdfile)
  execute 'e ' . mdfile
endfunction


command! SaveSession :call CreateSession()
command! OpenSession :call OpenSession()
command! SaveNote :call CreateNote()
command! OpenNote :call OpenNote()
