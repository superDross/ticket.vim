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


if !exists('g:ticket_overwrite_confirm')
  let g:ticket_overwrite_confirm = 0
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


augroup QuickFixMappings
  " tried <CR> but cannot get it to only apply when FindSessions is used
  " instead we opt for `O` as a means of calling source on the given selection
  autocmd filetype qf 
    \ nnoremap <buffer> O :execute 'source ' . split(getline('.'), '\|')[0]<CR>
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
  command! -bang -nargs=* GrepNotes :call ticket#fzf#notes#FzfNotes(<q-args>)
  command! -bang -nargs=* FindSessions :call ticket#fzf#sessions#FzfSessions(<q-args>)
else
  command! -nargs=1 GrepNotes :call ticket#notes#GrepNotes(<f-args>)
  command! -nargs=* FindSessions :call ticket#sessions#FindSessions(<q-args>)
endif

command! -bang -nargs=* TicketNotesFzf :call ticket#fzf#notes#FzfNotes(<q-args>)
command! -bang -nargs=* TicketSessionsFzf :call ticket#fzf#sessions#FzfSessions(<q-args>)
