" Auto.vim
"
" Functions associated with automatically open and saving sessions


function! _ShouldAuto(action)
  " determine whether we should automatically open or save a session
  let action_dict = {'open': g:auto_ticket_open, 'save': g:auto_ticket_save}
  if g:auto_ticket || action_dict[a:action]
    if BranchInBlackList() || IfBufferGitOperation() || !CanUseAutoInThisDir()
      return 0
    endif
  return 1
  endif
endfunction


function! ShouldAutoOpen()
  " determine if we should automically open a session
  return _ShouldAuto('open')
endfunction


function! ShouldAutoSave()
  " determine if we should automically save a session
  return _ShouldAuto('save')
endfunction


function! AutoOpenSession()
  " opens session only if no files arguments have been parsed to vim at the
  " command line then force redraw to remove any visual artifacts.
  if argc() ==# 0
    call OpenSession()
    redraw!
  endif
endfunction


function! CanUseAutoInThisDir()
  " determine if auto open/save functionality should open only in the current
  " directory if it is a git repo
  if g:auto_ticket_git_only && CheckIfGitRepo()  || !g:auto_ticket_git_only
    return 1
  endif
  return 0
endfunction
