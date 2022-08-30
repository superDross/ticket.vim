" Git.vim
"
" All git command line interactions are stored here

function! ticket#git#CheckIfGitRepo()
  " returns 1 if working directory is a git repository, otherwise returns 0
  let msg = system('git rev-parse --is-inside-work-tree')
  return matchstr(msg, '.*not a git repository.*') ==# msg ? 0 : 1
endfunction


function! ticket#git#GetRepoName()
  " returns remote name if set, otherwise top directory name is returned
  if system('git config --get remote.origin.url') !=# ''
    return system('basename -s .git $(git config --get remote.origin.url) | tr -d "\n"')
  else
    return system('basename $(git rev-parse --show-toplevel) | tr -d "\n"')
  endif
endfunction


function! ticket#git#GetBranchName()
  " returns the branch name checked out in the current working directory
  return system('git symbolic-ref --short HEAD | tr "/" "\n" | tail -n 1 | tr -d "\n"')
endfunction


function! ticket#git#GetAllBranchNames()
  " returns a list of all branch names (stripped of feature/bugfix prefix)
  " associated within the current repo
  return split(
  \ system(
  \    "git for-each-ref --format='%(refname:short)' refs/heads | sed 's@.*/@@'"
  \ )
  \)
endfunction


function! ticket#git#IfBufferGitOperation()
  " determines if current buffer is a git commit or rebase type
  let buftype = fnamemodify(bufname("%"), ":t")
  if buftype ==# 'COMMIT_EDITMSG' || buftype ==# 'git-rebase-todo'
    return 1
  endif
  return 0
endfunction
