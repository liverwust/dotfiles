# dotvim

My .vim directory, .vimrc file, and .gvimrc file

## license

MIT outside of the git submodules. See LICENSE.txt.

# Bootstrapping

This repo uses [homeshick](https://github.com/andsens/homeshick). The
sequence for accessing the configs on a new machine is:

1. git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
2. source $HOME/.homesick/repos/homeshick/homeshick.sh
3. homeshick clone liverwust/dotfiles
4. respond "y" when prompted about symlinking

Regarding step #4: if using a shared account (at work), don't clobber
existing homedir files. Instead, run this and then 'vim' will be aliased
to use the appropriate config files temporarily:

5. source $HOME/.homesick/repos/dotvim/wrapper.sh
