" Git.vim
"
" All git command line interactions are stored here

function! ticket#git#CheckIfGitRepo() abort
  " returns 1 if working directory is a git repository, otherwise returns 0
  let msg = system('git rev-parse --is-inside-work-tree')
  return matchstr(msg, '.*not a git repository.*') ==# msg ? 0 : 1
endfunction


function! ticket#git#GetRepoName() abort
  " returns remote name if set, otherwise top directory name is returned
  if system('git config --get remote.origin.url') !=# ''
    let remote_name = system('git config --get remote.origin.url')
  else
    let remote_name = system('git rev-parse --show-toplevel')
  endif
  let basename = fnamemodify(remote_name, ':t')
  return substitute(basename, '\n\|.git', '','g')
endfunction


function! ticket#git#GetBranchName() abort
  " returns the branch name checked out in the current working directory.
  " removes newlines or leading branch prefixes (e.g. feature/, bugfix/ etc.)
  let full_branch_name = system('git symbolic-ref --short HEAD')
  return substitute(full_branch_name, '.*/\|\n', '', 'g')
endfunction


function! ticket#git#GetAllBranchNames() abort
  " returns a list of all branch names (stripped of feature/bugfix prefix)
  " associated within the current repo
  let branchnames = split(
  \  system("git for-each-ref --format='%(refname:short)' refs/heads")
  \)
  return map(branchnames, "substitute(v:val, '.*/', '', '')")
endfunction


function! ticket#git#IfBufferGitOperation() abort
  " determines if current buffer is a git commit or rebase type
  let buftype = fnamemodify(bufname('%'), ':t')
  if buftype ==# 'COMMIT_EDITMSG' || buftype ==# 'git-rebase-todo'
    return 1
  endif
  return 0
endfunction
