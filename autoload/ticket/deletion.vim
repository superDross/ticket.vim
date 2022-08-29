" Delete.vim
"
" Module dealing with deletion of session files


function ticket#deletion#DeleteFiles(files)
  " delete all files in a given list
  for file in a:files
    call system('rm ' . file)
  endfor
endfunction


function ticket#deletion#DeleteOldSessions(force_input)
  " removes sessions files that no longer have local branches
  " only works within directories that are git repositories
  if ticket#git#CheckIfGitRepo() == 0
      throw 'Sessions can only be deleted within a git repository.'
  endif
	
  let deletelist = ticket#files#GetSessionsWithoutBranches()

  if deletelist ==# []
    echo "No sessions found to remove"
    return
  endif

  echo join(deletelist, "\r")
  let question = 'Are you sure you want to delete the above session files? (y/n): '
  let answer = a:force_input == 1 ? "y" : input(question)

  if answer ==# 'y'
    call ticket#deletion#DeleteFiles(deletelist)
  endif

endfunction
