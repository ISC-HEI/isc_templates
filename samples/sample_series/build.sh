#!/bin/bash

echo 
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "Building LaTeX files (rev 2.01 in WSL for TeXLive)"
echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo  

rm *.aux *.out *.log

for filename in *.tex; do
    # Remove extension
    name="${filename%.*}"
    echo 
    echo "*************** Building $name"
    echo 
    latexmk -quiet -time -pdf -jobname="$name" 
    
    echo 
    echo "*************** Building solution of $name"
    echo 
    latexmk -quiet -time -pdf -jobname="$name-sol" -pdflatex='pdflatex %O -interaction=batchmode "\def\withanswers{}\input{%S}"' 
    
    # Cleaning up 
    latexmk -quiet -jobname="$name" -c
    latexmk -quiet -jobname="$name-sol" -c
    
    # echo 
    # echo "*************** Copying to solution folder"
    # echo 
    # cp "$name.pdf" '../series_pdf/'
    # cp "$name-sol.pdf" '../series_pdf/solutions/'
done
