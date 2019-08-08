" ticket.vim - Ticket
" Author:      David Ross <https://github.com/superDross/>
" Version:     0.1


function! CheckIfGitRepo()
  let msg = system('git log')
  try
    if stridx(msg, 'fatal') ==# 0
      throw 'git error'
    endif
  catch /.*/
    echoerr 'The current directory is not a git repository'
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
  execute 'source ' . sessionfile
endfunction


function! CreateNote()
  let mdfile = GetFilePath('.md')
  execute 'w ' . mdfile
endfunction


function! OpenNote()
  let mdfile = GetFilePath('.md')
  execute 'e ' . mdfile
endfunction


command! SaveSession :call CreateSession()
command! OpenSession :call OpenSession()
command! SaveNote :call CreateNote()
command! OpenNote :call OpenNote()
