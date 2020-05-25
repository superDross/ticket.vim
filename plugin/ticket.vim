" ticket.vim - Ticket
" Author:      David Ross <https://github.com/superDross/>
" Version:     0.2


if exists('g:ticket_auto_save') ==# 0
  let g:ticket_auto_save = 0
endif


if exists('g:ticket_auto_open') ==# 0
  let g:ticket_auto_open = 0
endif


function! CheckFileExists(file)
  try
    if filereadable(expand(a:file))
      return a:file
    else
      throw 'no file'
    endif
  catch /.*no file/
    echoerr 'File ' . a:file . ' does not exist'
  endtry
endfunction


function! CheckIfGitRepo()
  let msg = system('git log')
  try
    if matchstr(msg, '.*not a git repository.*') ==# msg
      throw 'not a repo'
    elseif matchstr(msg, '.*does not have any commits yet.*') ==# msg
      throw 'no commits'
    endif
  catch /.*not a repo/
    echoerr 'The current directory is not a git repository'
  catch /.*no commits/
    echoerr 'Make an initial branch commit before saving a session'
  endtry
endfunction


function! GetRepoName()
  " returns remote name if set, otherwise top directory name is returned
  if system('git config --get remote.origin.url') !=# ''
    return system('basename -s .git `git config --get remote.origin.url` | tr -d "\n"')
  else
    return system('basename `git rev-parse --show-toplevel` | tr -d "\n"')
  endif
endfunction


function! GetBranchName()
  return system('git symbolic-ref --short HEAD | tr "/" "\n" | tail -n 1 | tr -d "\n"')
endfunction


function! GetDirPath()
  let dirpath = '~/.tickets/' . GetRepoName()
  call system('mkdir -p ' . dirpath)
  return dirpath
endfunction


function! GetFilePath(extension)
  call CheckIfGitRepo()
  let branchname = GetBranchName()
  let dirpath = GetDirPath()
  return dirpath . '/' . branchname . a:extension
endfunction


function! GetFilePathOnlyIfExists(extension)
  let filepath = GetFilePath(a:extension)
  call CheckFileExists(filepath)
  return filepath
endfunction


function! CreateSession()
  let sessionfile = GetFilePath('.vim')
  execute 'mksession! ' . sessionfile
endfunction


function! OpenSession()
  let sessionfile = GetFilePathOnlyIfExists('.vim')
  execute 'source ' . sessionfile
endfunction


function! CreateNote()
  let mdfile = GetFilePath('.md')
  execute 'w ' . mdfile
endfunction


function! OpenNote()
  let mdfile = GetFilePathOnlyIfExists('.md')
  execute 'e ' . mdfile
endfunction


function! GrepNotes(query)
  let ticketsdir = expand('~') . '/.tickets/**/*.md'
  execute 'vimgrep! /\c' . a:query . '/j ' . ticketsdir
endfunction


function! DetermineAutoSave()
  " only autosave if file is in a valid git repo
  if g:ticket_auto_save
    try 
      call CheckIfGitRepo()
      return 1
    catch /.*/
      return 0
    endtry
  endif
endfunction


function! DetermineAutoOpen()
  " only auto open if the session file exists
  if g:ticket_auto_open
    try
      call GetFilePathOnlyIfExists('.vim')
      return 1
    catch /.*/
      return 0
    endtry
  endif
endfunction


augroup ticket
  if DetermineAutoSave()
    if DetermineAutoOpen()
      autocmd VimEnter * :if argc() ==# 0 | call OpenSession() | endif
    endif
    autocmd VimLeavePre,BufWritePost * :call CreateSession()
  endif
augroup END


command! SaveSession :call CreateSession()
command! OpenSession :call OpenSession()
command! SaveNote :call CreateNote()
command! OpenNote :call OpenNote()
command! -nargs=1 GrepNotes :call GrepNotes(<f-args>)
command! -bang -nargs=* GrepTicketNotesFzf
  \ call fzf#vim#grep(
  \   'rg --type md --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'dir': '~/.tickets/'}), <bang>0)

nnoremap <Leader>ng :GrepTicketNotesFzf<CR>
nnoremap <Leader>ns :SaveNote<CR>
nnoremap <Leader>no :OpenNote<CR>
