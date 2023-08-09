#!/bin/bash

echo .
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "Building LaTeX files (rev 2.0 in WSL for TeXLive)"
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo . 

for filename in *.tex; do
    # Remove extension
    name="${filename%.*}"
    echo 
    echo "*************** Building $name"
    echo 
    latexmk -quiet -time -pdf -jobname="$name"
    latexmk -quiet -time -pdf -jobname="$name" -c
    
    echo 
    echo "*************** Building solution of $name"
    echo 
    latexmk -quiet -time -pdf -jobname="$name-sol" -pdflatex='pdflatex %O -interaction=batchmode -synctex=1 "\def\withanswers{}\input{%S}"'
    latexmk -quiet -time -pdf -jobname="$name-sol" -c
    
done
