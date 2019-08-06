" ticket.vim - Ticket
" Author:      David Ross <https://github.com/superDross/>
" Version:     0.1


function! GetBranchName()
  return system('git symbolic-ref --short HEAD | tr "/" "\n" | tail -n 1 | sed "s/case-//" | tr -d "\n"')
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


command! Ticket :call CreateTicketSession()
command! OpenTicket :call OpenTicketSession()
command! Note :call CreateNoteFile()
command! OpenNote :call OpenNoteFile()
