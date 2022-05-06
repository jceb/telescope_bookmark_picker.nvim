# Telescope Bookmark Opener

Open GTK 3.0 bookmarks in new tab.

## Install

### Packer

```lua
use 'jceb/telescope_bookmark_picker.nvim'
```

## Telescope Setup

```lua
require('telescope').load_extension('bookmark_picker')
```

## Configuration

This extension can be configured using `extensions` field inside Telescope setup
function.

```lua
require'telescope'.setup {
  extensions = {
    bookmark_picker = {
      bookmarks_file = vim.fn.expand("~/.config/gtk-3.0/bookmarks")
    }
  },
}
```

## Available commands

```viml
:Telescope bookmark_picker

"Using lua function
lua require('telescope').extensions.bookmark_picker.bookmark_picker()
```

## References

- Code structure copied from
  [telescope_sessions_picker.nvim](https://github.com/JoseConseco/telescope_sessions_picker.nvim)
