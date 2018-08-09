#!/bin/bash

## Print a single line
echo Hello World

## To print multiple lines, We have to enable escape sequence.. \n, Yet it will not work unless you enable -e option with echo command.
echo -e "Line1\nLine2"
# Note: when ever you use -e option, Always provide the input in Double Quotes

## Print Colors also by using escape sequence \e
## \e[COLm 
## COL are RED (31) GREEN (32) YELLLOW (33) BLUE (34) MAGENTA (35) CYAN (36)
echo -e "\e[31mHello"
echo -e "\e[32mHello"
echo -e "\e[33mHello"
echo -e "\e[34mHello"
echo -e "\e[35mHello"
echo -e "\e[36mHello"

### Diable the color using 0m

echo -e "\e[33mHello World\e[0m"
echo Good Morning

# https://misc.flogisoft.com/bash/tip_colors_and_formatting