# My dotfiles

These are the dotfiles I use for my everyday work on Git Bash, MacOS, and
linux. They are focused on bash, vim, and my dev tools (eclipse, intellij,
etc.).

## How to Use

1. Clone this repo
2. Run its bootstrap script `$ bsdots -b`

## How it Works

The script creates symbolic links to the dotfiles in the repo. EXCEPT on Git
Bash, it copies the dotfiles into the `$HOME`, and refreshes them on each
launch (because symbolic link support on windows is yucky).
