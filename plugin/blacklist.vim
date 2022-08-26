" Blacklist.vim
"
" Functions associated with the black list feature


function! BranchInBlackList()
  " determines if the branch name in the working directory is within the user
  " defined black list
  let branchname = GetBranchName()
  if (index(g:ticket_black_list, branchname) >= 0)
    return 1
  endif
  return 0
endfunction


