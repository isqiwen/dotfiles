#!/usr/bin/env bash

echo "Type in your first and last name (no accent or special characters - e.g. 'ç'): "
read full_name

echo "Type in your email address (the one used for your GitHub account): "
read email

echo "Type in your editor (the one used for you to create and edit your commit - e.g. code/nvim): "
read editor

git config --global user.email "$email"
git config --global user.name "$full_name"
git config --global core.editor "$editor"

echo "👌 Awesome, all set."
