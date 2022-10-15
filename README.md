# ticket.vim

Vim session management system with a focus on git branches.

![](https://user-images.githubusercontent.com/16519378/185827909-3c80e95f-668b-4d6f-b113-86d9d805eef6.gif)

## Usage

### Within a Git Repo

Executing `:SaveSession` will save a session associated with the current branch checked out within the repo.

Executing `OpenSession` will open the session you saved that is associated with the current branch name.

If you switch branch you can save/open a different session associated with the branch you just switched to without affecting other branch sessions.

Markdown files for taking notes associated with the branch can be managed using `:SaveNote` and `:OpenNote`

### Outside a Git Repo

Saving and opening sessions will work and automatically name the session file `main.vim` in case the directory is ever initialised as a git repo.

## Commands

### Sessions

- `:SaveSession` -- To create a session 

- `:OpenSession` -- Open a session

- `:DeleteSession` -- Delete the session associated with the current git repo or directory

- `:CleanupSessions` -- Remove sessions that do not have a local branch (only works within git repositories)

- `:ForceCleanupSessions` -- Same as `CleanupSession` but forcefully removes without prompting user (only works within git repositories)

- `:FindSessions *` -- Search all session files name for a given arg and open the quickfix menu

- `:SessionsFzf` -- Use fzf to search and open sessions (requires [fzf.vim](https://github.com/junegunn/fzf.vim) or [fzf-lua](https://github.com/ibhagwan/fzf-lua))


### Notes

- `:SaveNote` -- Save notes related to the session

- `:OpenNote` -- Open note associated with the session

- `:DeleteNote` -- Delete the note associated with the current git repo or directory

- `:GrepNotes *` -- Search all notes for given arg

- `:TicketNotesFzf` -- Use fzf to grep  and open notes (requires [fzf.vim](https://github.com/junegunn/fzf.vim) or [fzf-lua](https://github.com/ibhagwan/fzf-lua))


## Settings

### Automatic Session Saving/Opening

To automatically open and save session files when opening/closing vim set the following in your `.vimrc`:

```vim
let g:auto_ticket = 1
```

To automatically open session files when **only** opening vim set the following in your `.vimrc`:

```vim
let g:auto_ticket_open = 1
```

To automatically save session files when **only** closing vim set the following in your `.vimrc`:

```vim
let g:auto_ticket_save = 1
```

To **only** allow the auto feature to work in git repo directories set the following in your `.vimrc`:

```vim
let g:auto_ticket_git_only = 1
```

Black list some branches from being used with the auto feature:

```vim
let g:ticket_black_list = ['master', 'other-branch']
```

### Overriding Default Values

Define a default branch name that will used to name all non git repo session files (default: main):

```vim
let g:default_session_name = 'master'
```

Define the directory you want to store all session files within:

```vim
let g:session_directory = '~/my_dir'
```

Use `fzf` instead of vimgrep when executing `:GrepNotes` or `FindSessions`:

```vim
let g:ticket_use_fzf_default = 1
```

Print save/open messages when saving/opening sessions/notes:

```vim
let g:ticket_very_verbose = 1
```


## Installation

Requires vim 8.1+ or neovim 0.5+.

With [Vim-Plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'superDross/ticket.vim'
" alternatively pin to specific version (useful if experiencing bugs with a new release)
Plug 'superDross/ticket.vim', { 'tag': '0.10.1' }
```

With [Packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
require('packer').startup(function(use)
  use 'superDross/ticket.vim'
  -- alternatively pin to specific version (useful if experiencing bugs with a new release)
  use {
      'superDross/ticket.vim',
      tag = '0.10.1',
  }
end)
```

## File Storage

The session files are stored as below; git repository directory name with all branch specific session and note files within it.

```
~/.local/share/tickets-vim/
│
└── <repository-name>/
   ├── <branch-name>.md
   └── <branch-name>.vim
```

The legacy root directory is `~/.tickets`, however, if this is not currently being used (or it has not been set via `g:session_directory`) then the [XDG base directory spec](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) will be followed.

This will check and prioritise the directory set in `$XDG_DATA_HOME`, if not set then `~/.local/share` will be used.

## Limitations

- The organisation and storage of the branch based session files depends upon the repo & git branch pairing name being unique.

- Only works within \*NIX based systems.

- This plugin assumes it has the appropriate permissions for modifying files locally

## Developing

When creating fixes/features you can test that your changes do not break any existing features by executing the following make command in the root directory of the project:

```sh
make tests
```
