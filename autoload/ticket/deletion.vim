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
  " force_input: either 0 or 1, 1 means not prompting user before deleting
  if ticket#git#CheckIfGitRepo() == 0
      throw 'Sessions can only be deleted within a git repository.'
  endif
	
  let deletelist = ticket#files#GetSessionsWithoutBranches()

  if deletelist ==# []
    echo "No sessions found to remove"
    return
  endif

  if a:force_input
    let answer = "y"
  else
    echo join(deletelist, "\r")
    let answer = input('Are you sure you want to delete the above session files? (y/n): ')
  endif

  if answer ==# 'y'
    call ticket#deletion#DeleteFiles(deletelist)
  endif

endfunction
