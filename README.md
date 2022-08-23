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

- `:SaveNote` -- Save notes related to the session

- `:OpenNote` -- Open note associated with the session

- `:GrepNotes *` -- Search all notes for given arg

- `:GrepTicketNotesFzf` -- FZF grep notes (requires [FZF](https://github.com/junegunn/fzf.vim)


## Settings

To automatically open and save session files when opening/closing vim set the following in your `.vimrc`:

```vim
let g:auto_ticket = 1
```

Black list some branches from being used with the auto feature:

```vim
let g:auto_ticket = 1
let g:ticket_black_list = ['master', 'other-branch']
```

Define a default branch name that will used to name all non git repo session files (default: main):

```vim
let g:default_session_name = 'master'
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
~/.tickets/
│
└── <repository-name>/
   ├── <branch-name>.md
   └── <branch-name>.vim
```

## Limitations

- The organisation and storage of the branch based session files depends upon the repo & git branch pairing name being unique.

- Only works within \*NIX based systems.
