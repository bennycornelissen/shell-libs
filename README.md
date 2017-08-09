# Shell Libs

## What is it?
Some shell function libraries with stuff that I use in my dotfiles.

## How do I use it?
I personally include this repo as a submodule in my dotfiles: 

```
$ git submodule add <this repo URL> <dotdir/.shell-libs>
$ git submodule init
```

I can update to the latest commit quickly while pulling my latest dotfiles:

```
$ git pull --recurse-submodules
```

Sourcing the different libs is done like this:

```
# Load envtools
if [ -r ${HOME}/.shell-libs/envtools.sh ]; then
  source ${HOME}/.shell-libs/envtools.sh
fi

# Load envtools completion for bash
if [ -r ${HOME}/.shell-libs/envtools-completion-bash.sh ]; then
  source ${HOME}/.shell-libs/envtools-completion-bash.sh
fi
```

## Why is the completion in a separate file?
I shared an early version of this with a friend who uses ZSH, and while he liked the envtools functions, the completion didn't work. So I split it off.

## It doesn't work on my system!
That's possible. But then again, this repo comes with no warranty and no support. If it works for you, great. If it doesn't, figure out why. 
