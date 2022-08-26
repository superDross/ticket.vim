" Auto.vim
"
" Functions associated with automatically open and saving sessions


function! DetermineAuto()
  " determines whether we auto save/open or not open file opening
  if g:auto_ticket
    " only autosave if the current branch is not black listed or a git op
    if BranchInBlackList() ==# 1 || IfBufferGitOperation() ==# 1
      return 0
    endif

    return 1
  endif
endfunction


function! AutoOpenSession()
  " opens session only if no files arguments have been parsed to vim at the
  " command line then force redraw to remove any visual artifacts.
  if argc() ==# 0
    call OpenSession()
    redraw!
  endif
endfunction
