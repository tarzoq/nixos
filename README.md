# nixos
My personal NixOS config

## Installation
1. ``git clone https://github.com/tarzoq/nixos.git ~``
1. ``cp ~/nixos/variables.nix.template ~/nixos/variables.nix`` (adjust it to your needs)
1. ``sudo ln -s ~/nixos/variables.nix /etc/nixos/variables.nix``
1. If new computer, copy one of the folders in ``/hosts``, name it something appropriate, and tailor the ``default.nix``-file for the computer.
1. ``sudo nixos-rebuild boot --impure --flake ~/nixos#HOSTNAME``
