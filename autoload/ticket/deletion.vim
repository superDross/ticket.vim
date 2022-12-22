" Delete.vim
"
" Module dealing with deletion of session files


function! s:DeleteFiles(files) abort
  " delete all files in a given list
  " files: list of files to delete
  for file in a:files
    call delete(file)
  endfor
endfunction


function! ticket#deletion#DeleteSession() abort
  " delete the session associated with the current git repo or directory
  return ticket#deletion#DeleteCurrentAssociatedFile('vim', 0)
endfunction


function! ticket#deletion#DeleteNote() abort
  " delete the note associated with the current git repo or directory
  return ticket#deletion#DeleteCurrentAssociatedFile('md', 0)
endfunction


function! ticket#deletion#DeleteCurrentAssociatedFile(ext, force_input) abort
  " delete the session/note associated with the current git repo or directory
  " ext: either 'vim' or 'md' to denote the file extension
  " force_input: either 0 or 1, 1 means not prompting user before deleting
  let file = ticket#files#GetSessionFilePathOnlyIfExists(a:ext)

  " TODO: if the answer is not y/yes/Y/YES/n/no/N/NO then ask user to input
  " again
  let q = 'Are you sure you want to delete ' . fnamemodify(file, ':t') . '? (y/n): '
  let answer = a:force_input == 1 ? 'y' : input(q)

  if tolower(answer) ==# 'y'
    call delete(file)
  endif
endfunction


function! ticket#deletion#DeleteOldSessions(force_input) abort
  " removes sessions files that no longer have local branches
  " only works within directories that are git repositories
  " force_input: either 0 or 1, 1 means not prompting user before deleting
  if ticket#git#CheckIfGitRepo() == 0
      throw 'Sessions can only be deleted within a git repository.'
  endif
	
  let deletelist = ticket#files#GetSessionsWithoutBranches()

  if deletelist ==# []
    echo 'No sessions found to remove'
    return
  endif

  let q = join(deletelist, "\n") . "\n\n" .
    \ 'Are you sure you want to delete the above session files? (y/n): '
  let answer = a:force_input == 1 ? 'y' : input(q)

  if tolower(answer) ==# 'y'
    call s:DeleteFiles(deletelist)
  endif

endfunction
