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

- `:SaveSession` -- To create a session 

- `:OpenSession` -- Open a session

- `:CleanupSessions` -- Remove sessions that do not have a local branch (only works within git repositories)

- `:ForceCleanupSessions` -- Same as `CleanupSession` but forcefully removes without prompting user (only works within git repositories)

- `:SaveNote` -- Save notes related to the session

- `:OpenNote` -- Open note associated with the session

- `:GrepNotes *` -- Search all notes for given arg

- `:GrepTicketNotesFzf` -- FZF grep notes (requires [FZF](https://github.com/junegunn/fzf.vim) & does not work with neovim)


## Settings

### Automatic Session Saving/Opening

To automatically open and save session files when opening/closing vim set the following in your `.vimrc`:

```vim
let g:auto_ticket = 1
```

To automatically open session files when **only** opening vim set the following in your `.vimrc`:

```vim
let g:auto_open = 1
```

To automatically save session files when **only** closing vim set the following in your `.vimrc`:

```vim
let g:auto_save = 1
```

To **only** allow the auto feature to work in git repo directories set the following in your `.vimrc`:

```vim
let g:auto_git_only = 1
```

Black list some branches from being used with the auto feature:

```vim
let g:auto_ticket = 1
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

## Installation

With [Vim-Plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'superDross/ticket.vim'
```

With [Packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
require('packer').startup(function(use)
  use 'superDross/ticket.vim'
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
