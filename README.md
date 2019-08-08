# ticket.vim

Creates and manges branch specific session files.

## Usage

To create a branch session `:SaveSession`

To open it `:OpenSession`

To save branch notes `:SaveNote`

To open it `:OpenNote`

## Caveats

The organisation and storage of the session files depends on the git branch name being unique.

### Example

Say you are currently in branch `feature/case-34200` in the `NewProject` repo and subsequently execute `:SaveSession` within vim.

The session file will be stored within `~/.tickets/NewProject/case-34200.vim`.

To open this specific session with `:OpenSession`, you must be in branch `feature/case-34200`.

## Installation

For vim-plug

```vim
Plug 'superDross/ticket.vim'
```
