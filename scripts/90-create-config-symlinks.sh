#!bin/bash

for folder in ./dotfiles/.config/*; do
  ln -s $(realpath $folder) ~/.config/$(basename $folder)
done
