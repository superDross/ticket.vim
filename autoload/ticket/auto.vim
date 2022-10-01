" Auto.vim
"
" Functions associated with automatically open and saving sessions


function! ticket#auto#ShouldAuto(action) abort
  " determine whether we should automatically open or save a session
  let action_dict = {'open': g:auto_ticket_open, 'save': g:auto_ticket_save}
  if g:auto_ticket || action_dict[a:action]
    if ticket#blacklist#BranchInBlackList() || 
    \  ticket#git#IfBufferGitOperation() ||
    \  !ticket#auto#CanUseAutoInThisDir()
      return 0
    endif
  return 1
  endif
endfunction


function! ticket#auto#ShouldAutoOpen() abort
  " determine if we should automically open a session
  return ticket#auto#ShouldAuto('open')
endfunction


function! ticket#auto#ShouldAutoSave() abort
  " determine if we should automically save a session
  return ticket#auto#ShouldAuto('save')
endfunction


function! ticket#auto#AutoOpenSession() abort
  " opens session only if no files arguments have been parsed to vim at the
  " command line then force redraw to remove any visual artifacts.
  if argc() ==# 0
    call ticket#sessions#OpenSession()
    redraw!
  endif
endfunction


function! ticket#auto#CanUseAutoInThisDir() abort
  " determine if auto open/save functionality should open only in the current
  " directory if it is a git repo
  let is_git_repo = ticket#git#CheckIfGitRepo()
  if g:auto_ticket_git_only && is_git_repo || !g:auto_ticket_git_only
    return 1
  endif
  return 0
endfunction
