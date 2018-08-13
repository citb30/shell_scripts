#!/bin/bash

## Parsing the input as argument and access those arguments inside script using variables.
## Variables are $0,$1,$2..$n, $*, $@, $# 

## $0 -> TO access the script name which wee are executing
echo "Script Name = $0"
echo "FIrst Argument = $1"
echo "All the arguments which are parsed = $*"
echo "All the arguments which are parsed = $@"
echo "Number of arguments which are parsed = $#"
