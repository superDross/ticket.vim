" ticket.vim - Session Management Tooling
" Author:      David Ross <https://github.com/superDross/>


if !exists('g:auto_ticket')
  let g:auto_ticket = 0
endif


if !exists('g:ticket_black_list')
  let g:ticket_black_list = []
endif


if !exists('g:default_session_name')
  let g:default_session_name = 'main'
endif


if !exists('g:session_directory')
  " ~/.tickets should be hard coded within the function, it is not simply for
  " testing purposes
  let g:session_directory = GetRootTicketDir('~/.tickets')
endif


augroup AutoTicket
  " automatically open and save sessions
  if DetermineAuto()
    let session_file_path = GetSessionFilePath('.vim')
    if filereadable(expand(session_file_path))
      " ++nested is required as downstream operations trigger autocommands
      autocmd VimEnter * ++nested :call AutoOpenSession()
    else
      call CreateSession()
    endif
    autocmd VimLeavePre,BufWritePost * ++nested :call CreateSession()
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
  \   fzf#vim#with_preview({'dir': g:session_directory}), <bang>0)
