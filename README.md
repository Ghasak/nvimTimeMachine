# Nvim Time Machine

## Introduction
You can run the command line to create, list and restore your nvim and roll-back to the date you created your nvim backup.
There are so many other options available created by many great developers, but
I wanted something easy to be used and getting full control. Instead of
reading all error messages and roll-back defected plugins by the new update.

## Requirements

Currently this script support working on Mac mainly, in both `Intel` and `Arm64`-based systems.
dependencies=(
- `pv`
- `zip`
- `gdu` for `GNU Linux` you can use `du` instead of `gd`
Please check the --help for more details.

## How to use
```bash
#Usage:
nvimTime [OPTIONS]
	cc   | --create_capsule${NC})    : create a new capsules
	l    | --list_capsules${NC})     : list all saved capsules
	rc   | --restore_capsule${NC})   : restore a capsule
	[vV] | --version${NC})           : current CLI version
	[hH] | --help${NC})              : show this help

```
## Installation Instructions
```bash
mkdir ~/.nvimTimeMachine # or whatever directory you want
cd ~/.nvimTimeMachine
touch nvimTimeMachine
git clone git@github.com:Ghasak/nvimTimeMachine.git ~/.nvimTimeMachine
chmod -x ~/.nvimTimeMachine/nvimTimeMachine
ln -s ~/.nvimTimeMachine/nvimTimeMachine /usr/bin/
# Or
# In your .profile, or .zshrc or .bashrc whatever is your running shell, put
source PATH="$PATH:$HOME/.nvimTimeMachine/"
```


