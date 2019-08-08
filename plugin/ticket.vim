" ticket.vim - Ticket
" Author:      David Ross <https://github.com/superDross/>
" Version:     0.1


function! CheckGit()
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


function! GetTicketDir()
  let sessionpath = '~/.tickets/' . GetRepoName()
  execute 'silent !mkdir -p ' . sessionpath
  execute 'redraw!'
  return sessionpath
endfunction


function! GetFilePath(suffix)
  call CheckGit()
  let sessionname = GetBranchName()
  let sessionpath = GetTicketDir()
  return sessionpath . '/' . sessionname . a:suffix
endfunction


function! CreateTicketSession()
  let sessionfile = GetFilePath('.vim')
  execute 'mksession! ' . sessionfile
endfunction


function! OpenTicketSession()
  let sessionfile = GetFilePath('.vim')
  execute 'source ' . sessionfile
endfunction


function! CreateNoteFile()
  let mdfile = GetFilePath('.md')
  execute 'w ' . mdfile
endfunction


function! OpenNoteFile()
  let mdfile = GetFilePath('.md')
  execute 'e ' . mdfile
endfunction


command! SaveTicket :call CreateTicketSession()
command! OpenTicket :call OpenTicketSession()
command! SaveNote :call CreateNoteFile()
command! OpenNote :call OpenNoteFile()
