## Vim Yank Bank

Lightweight vim plugin for preserving yanks and system clipboard into named registers. It works by creating backups to an arbitrary number of registers specified by the user which are used to rotate the last 'n' yanks and clipboard yanks.

### Install

Use your favorite plugin manager

`Plug 'skamsie/vim-yank-bank'`

### Usage

In your vimrc, set the registers to use for storing yanks. You can use
any register, but it is not a good idea to use any of the numbered
registers or the special registers because vim uses them and it can lead to
unexpected results.

```vim
let g:yb_yank_registers = ["a", "s", "d", "f"]
let g:yb_clip_registers = ["j", "k", "l"]
```

Now if you yank something without explicitly specifying a register,
for example with `yy` or `yw`, the text is _also_ stored to register `a`. Yank again
and the previous yank is now in register `s` and the new yanked text is in `a`.
Each yank pushes the previous text to the next register specified in the array.

Same logic applies for text copied from system clipboard, but the registers
from `g:yb_clip_registers` are used for storing.

To check the registers used by yank-bank, you can use the `:YB`command, which is based
on the bult-in `:registers` command.

To paste something from a specific register, use the normal vim commands.

Get help at any time with `:help yank-bank`

**NOTES**

- After adding the global variables above in your vimrc, you need to restart
vim, sourcing is not enough.

- For preserving text copied from the system clipboard you need vim compiled with
clipboard support and 'FocusGained' and 'FocusLost' events support. The focus
events are usually available only for the GUI version and a few console versions,
for example neovim.

- If you want to remove the clipboard backup functionality, just remove the `g:yb_clip_registers` variable.

### Why another 'yanks' related vim plugin?

**A primer on yanking in vim**

In vim when you yank something, it is stored into the `"` unnamed register and
the `0` registers. If you yank again, these two registers are overwritten and
your yank is lost. Vim does not keep a backup of your yanks as it does for your
deletes. If you delete, only the unnamed register is overwritten and your last
yank stays in register `0` until you yank again.

You can read a pretty comprehensive article on vim registers and yanking [here](http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/)

**Why another plugin for dealing with this 'problem'?**

Because it leverages vim's builtin yank functionality without altering the default behavior.
It does not create any new mappings and it does not overwrite any commands. It's like you would use named
yanks everytime, but the plugin does it automatically for you.
