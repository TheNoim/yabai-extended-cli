# yabai-extended-cli

This is a simple helper cli I wrote for myself. It supports the following commands (all are the first argument of the cli):

- `next`: Got to the next space. If the current space is the last space, go to the first space
- `back`: Go to the space bevor the current one. If the current space is the first space, go to the last space
- `first`: Focus first space
- `last`: Focus last space
- `nextMoveWindow`: Take the currently focused window and move it to the next space and also focus it. If the current space is the last space, move it to the first space
- `backMoveWindow`: Take the currently focused window and move it to the space bevor the current one. If the current space is the first space, move it to the last space

All the commands use the space where the cursor is currently. So this also works, if the mouse is on another monitor. The monitor doesn't need to be focused, the mouse just needs to be on the desired monitor.

## Installation

There is no installation. You need to compile it by yourself or you download a compiled binary from [here](https://github.com/TheNoim/MacOS/blob/master/YabiExtendedCli).

I use it in combination with [BetterTouchTools](https://folivora.ai/). 
