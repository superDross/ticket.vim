" Sessions.vim
"
" High level functions for creating, opening and getting sessions


function! s:OverwriteConfirmed(sessionfile) abort
  " ask for user confirmation before overwriting the session file
  if filereadable(expand(a:sessionfile)) && g:ticket_overwrite_confirm
    let msg = 'WARNING: are you sure you want to overwrite
               \ the existing session file? (y/n): '
    echohl WarningMsg
    let answer = tolower(input(msg)) ==# 'y' ?  1 : 0
    echohl None
    redraw
    return answer
  endif
  return 1
endfunction


function! ticket#sessions#CreateSession() abort
  " creates or overwrites the session file associated with the git branch or
  " directory name in the working directory
  let sessionfile = ticket#files#GetSessionFilePath('.vim')
  if s:OverwriteConfirmed(sessionfile)
    execute 'silent mksession! ' . sessionfile
    call ticket#utils#VeryVerbosePrint('Session Saved: ' . sessionfile)
  endif
endfunction


function! ticket#sessions#OpenSession() abort
  " opens the session file associated with the git branch or directory name in
  " the working directory
  let sessionfile = ticket#files#GetSessionFilePathOnlyIfExists('.vim')
  execute 'silent source ' . sessionfile
  call ticket#utils#VeryVerbosePrint('Session Opened: ' . sessionfile)
endfunction


function! ticket#sessions#GetAllSessionNames(repo) abort
  " returns all session names associated with the given repo
  let files = globpath(g:session_directory . '/' . a:repo, '*.vim', 0, 1)
  return map(files, "fnamemodify(v:val, ':t:r')")
endfunction


function! ticket#sessions#FindSessions(query) abort
  " returns all notes file paths that contain the given query
  execute 'vimgrep /\%^/j ' . g:session_directory . '/**/*.vim'
  call ticket#utils#QuickFixFilter(a:query)
  " conceal file contents
  syntax match ConcealedDetails /\v\|.*/ conceal
  setlocal conceallevel=2
  setlocal concealcursor=nvic
endfunction
