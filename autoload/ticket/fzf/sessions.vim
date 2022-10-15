" fzf/Sessions.vim
"
" Fzf integration with session files


function! ticket#fzf#sessions#FzfSessionSelection(selection) abort
  " open session file selected via fzf.vim
  execute 'silent source ' . a:selection[1]
endfunction


function! ticket#fzf#sessions#FzfVimSessions(args = '') abort
  " find and open session files using FZF
  if ticket#utils#IsInstalled('fzf.vim')
    let wrapped = fzf#wrap('sessions', {
    \  'source': "find " . g:session_directory . " -type f -name '*.vim' ",
    \  'options': ['--query=' . a:args]
    \}, 0)
    let wrapped['sink*'] = function('ticket#fzf#sessions#FzfSessionSelection')
    return fzf#run(wrapped)
  else
    echoerr 'junegunn/fzf.vim is not loaded or installed'
  endif
endfunction


function! ticket#fzf#sessions#FzfLuaSessions(args = '') abort
  if ticket#utils#IsInstalled('fzf-lua')
    " we need to quit the fzf terminal before sourcing
    lua require('fzf-lua').files({
    \  file_icons = false,
    \  git_icons = false,
    \  previewer = false,
    \  cmd = "find " .. vim.g.session_directory .. " -type f -name '*.vim' ",
    \  actions = {
    \    ['default'] = {
    \       function(selected)
    \           vim.cmd('quit')
    \           vim.cmd('silent source ' .. selected[1])
    \       end,
    \    }
    \  }
    \})
    return
  else
    echoerr 'ibhagwan/fzf-lua is not loaded or installed'
  endif
endfunction


function! ticket#fzf#sessions#FzfSessions(args) abort
  " interactively search notes contents using junegunn/fzf.vim or fzf-lua
  if has('nvim') && ticket#utils#IsInstalled('fzf-lua')
    return ticket#fzf#sessions#FzfLuaSessions(a:args)
  endif
  return ticket#fzf#sessions#FzfVimSessions(a:args)
endfunction
