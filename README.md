# color utilities for Vim
c0lor is a Vim plugin.
It has a python package.
Recommended installation is by
cloning this repository and linking files locally.

    $ git clone https://github.com/ttm/c0lor
    $ cd c0lor
    $ sudo pip3 install -e ./plugin/c0lor/
    $ ln -s ./ ~/.vim/pack/prv/opt/c0lor

the name 'prv' of the directory (between pack and opt directories) is what I use for the plugins I made, you are welcome to use it to.

You can also install via PyPI and Vimball:
    $ sudo pip3 install c0lor
    $ mkdir tempo
    $ cd tempo
    $ wget xxxx
    $ vim xxxx

After using any of the install procedures,
remember to add
    pa c0lor
in your vimrc and to run helptags c0lor.

## more
Check doc/c0lor.txt for information about plugin's workings.

## contrib
Log issues in Github, ask to me or in vim_use email list.

:::
