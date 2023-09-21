#!/bin/bash

# Dependency: imagemagick
## Mac: brew install imagemagick

# Def colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
end=$'\e[0m'

echo "${red}[Author]${end} By ${yel}VP${end}@23.03.22"

quality="30"
echo "${yel}[Config]${end} 使用品質參數: $quality"

for file in *.jpg
do
#    echo "$file"
#    echo "filename: $(echo $file | sed -e 's/\.[^.]*$//')"
    echo "${grn}[Act]${end} $file -> ${yel}$(echo $file | sed -e 's/\.[^.]*$//').pdf${end}"
    convert "$file" -quality 30 "$(echo $file | sed -e 's/\.[^.]*$//').pdf"
done
