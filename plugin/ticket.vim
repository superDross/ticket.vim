" ticket.vim - Session Management Tooling
" Author:      David Ross <https://github.com/superDross/>


" prevents loading the plugin multiple times
if exists('g:loaded_ticket')
  finish
endif
let g:loaded_ticket = 1


if !exists('g:auto_ticket')
  let g:auto_ticket = 0
endif


if !exists('g:auto_ticket_open')
  let g:auto_ticket_open = 0
endif


if !exists('g:auto_ticket_save')
  let g:auto_ticket_save = 0
endif


if !exists('g:auto_ticket_git_only')
  let g:auto_ticket_git_only = 0
endif


if !exists('g:ticket_black_list')
  let g:ticket_black_list = []
endif


if !exists('g:default_session_name')
  let g:default_session_name = 'main'
endif


if !exists('g:ticket_very_verbose')
  let g:ticket_very_verbose = 0
endif


if !exists('g:session_directory')
  " ~/.tickets should be hard coded within the function, it is not simply for
  " testing purposes
  let g:session_directory = ticket#files#GetRootTicketDir('~/.tickets')
endif


augroup AutoTicket
  " automatically open and/or save sessions
  if ticket#auto#ShouldAutoOpen()
    let session_file_path = ticket#files#GetSessionFilePath('.vim')
    if filereadable(expand(session_file_path))
      " ++nested is required as downstream operations trigger autocommands
      autocmd VimEnter * ++nested :call ticket#auto#AutoOpenSession()
    endif
  endif

  if ticket#auto#ShouldAutoSave()
    autocmd VimLeavePre,BufWritePost * ++nested :call ticket#sessions#CreateSession()
  endif
augroup END


command! SaveSession :call ticket#sessions#CreateSession()
command! OpenSession :call ticket#sessions#OpenSession()
command! DeleteSession :call ticket#deletion#DeleteSession()
command! CleanupSessions :call ticket#deletion#DeleteOldSessions(0)
command! ForceCleanupSessions :call ticket#deletion#DeleteOldSessions(1)
command! SaveNote :call ticket#notes#CreateNote()
command! OpenNote :call ticket#notes#OpenNote()
command! DeleteNote :call ticket#deletion#DeleteNote()

if get(g:, 'ticket_use_fzf_default', 0)
  command! -bang -nargs=* GrepNotes :call ticket#notes#GrepNotesFzf(<q-args>)
else
  command! -nargs=1 GrepNotes :call ticket#notes#GrepNotes(<f-args>)
endif

command! -bang -nargs=* GrepTicketNotesFzf :call ticket#notes#GrepNotesFzf(<q-args>)
