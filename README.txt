# My dotfiles

These are the dotfiles I use for my everyday work on Git Bash,
MacOS, and linux. They are focused on bash, vim, and my dev
tools (eclipse, intellij, etc.).

After cloning this repo, run the bootstrap script:

    $ bsdots -b

To bootstrap in the dotfiles. It will create symbolic links
to the dotfiles in the repo. For Git Bash, it'll copy the
dotfiles into the $HOME, and refresh them on each launch
(because symbolic link support on windows is yucky).
