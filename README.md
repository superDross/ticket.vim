# ticket.vim

Creates and manges git branch specific session files.

## Function

This allows one to open and save session files associated with specific git branches easily. This is particularly useful if you need to switch branch, but want to preserve your vim state in the branch you are currently within.

When in the `branch1` you can execute `:SaveSession`, switch to `branch2` do what you need to do here then switch back to `branch1` and execute `OpenSession`. Your vim instance will look exactly the same as it was prior to switching to `branch2`.

In this way, each branch can have its very own session that can be easily opened (`:OpenSession`) and saved/overwritten (`:SaveSession`).

One can also have these session files automatically open and save.

Branch specific note files can be created & managed using `:OpenNote` & `:SaveNote`. This is useful when fixing a bug in a certain branch and you wish to document your findings while troubleshooting.

## Usage

To create a branch session `:SaveSession`

To open it `:OpenSession`

To save branch notes `:SaveNote`

To open it `:OpenNote`

To search all notes for git `:GrepNotes git`

To automatically open and save and session files set the following in your `.vimrc`:

```vim
let g:ticket_auto_open = 1
let g:ticket_auto_save = 1
```

## Installation

For vim-plug

```vim
Plug 'superDross/ticket.vim'
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

## Caveats

The organisation and storage of the session files depends upon the repo & git branch pairing name being unique.

Only works in UNIX based systems, this plugin has only been tested in Ubuntu.

## TODO

- Create a blacklist for auto open/save settings e.g. disallow auto session open/saving of the `master` branch.
- Increase testing coverage.
