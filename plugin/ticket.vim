" ticket.vim - Ticket
" Author:      David Ross <https://github.com/superDross/>
" Version:     0.1


function! GetRepoName()
  return system('basename -s .git `git config --get remote.origin.url`')
endfunction


function! GetBranchName()
  let branchname = system('git symbolic-ref --short HEAD | tr "/" "\n" | tail -n 1 | sed "s/case-//" | tr -d "\n"')
  if stridx(branchname, 'fatal') ==# 0
    throw branchname
  endif
  return branchname
endfunction


function! GetTicketDir()
  let caseid = GetBranchName()
  let sessionpath = '~/.tickets/' . caseid
  execute 'silent !mkdir -p ' . sessionpath
  execute 'redraw!'
  return sessionpath
endfunction


function! GetFilePath(suffix)
  let caseid = GetBranchName()
  let sessionpath = GetTicketDir()
  return sessionpath . '/' . caseid . a:suffix
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
  let mdfile = GetFilePath('-note.md')
  execute 'w ' . mdfile
endfunction


function! OpenNoteFile()
  let mdfile = GetFilePath('-note.md')
  execute 'e ' . mdfile
endfunction


command! SaveTicket :call CreateTicketSession()
command! OpenTicket :call OpenTicketSession()
command! SaveNote :call CreateNoteFile()
command! OpenNote :call OpenNoteFile()
