" Utils.vim
"
" Various utility functions used throughout the project


function! ticket#utils#IsInstalled(package) abort
  " check if the given package is installed or not
  let loaded_packages = filter(
    \ split(execute(':scriptname'), "\n"),
    \   'v:val =~? "' . a:package . '"'
    \ )
  if loaded_packages !=# []
    return 1
  endif
  return 0
endfunction


function! ticket#utils#VeryVerbosePrint(msg) abort
  " prints msg only if very verbose setting is activated
  if g:ticket_very_verbose ==# 1
    echo a:msg
  endif
endfunction


function! ticket#utils#DeprecatedCommand(old_command, new_command) abort
  " echos a deprecation message for a command
  echoerr 'DEPRECATED: ' . a:old_command . ' has been replaced with the ' . 
  \ a:new_command . ' command'
endfunction
