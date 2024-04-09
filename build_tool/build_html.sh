#!/bin/bash
VERSION="1.0.5"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DIR="."

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hno:" option; do
   case $option in
      n) # Enter a file name
         DIR="$OPTARG"
         ;;
      h) # not yet implemented
         echo "not yet implemented"
         exit
         ;;
      o) # Destination of PDF file        
         DEST_PDF="$OPTARG"
         ;;
      \?) # Invalid option
         echo "Error: invalid option"
         exit;;
   esac
done

file=("$DIR"/*.md)
input=${file[0]}

if [ -z "$input" ]; then
    echo "No .md file found in $DIR"
    exit 1
fi

echo "Compiling file '${input}'"
input=$(basename "$input")
output=${input/'.md'/'.html'}

pushd "$DIR" || exit

# --css="$SCRIPT_DIR/html_templates/sakura.css"
# options for maths is mathjax, mathml, katex
pandoc "${input}" -o "${output}" --from markdown+tex_math_dollars+raw_tex+emoji --katex --data-dir="$SCRIPT_DIR/html_templates" --template="GitHub2.html5" --toc --toc-depth=2 --embed-resources --standalone 

if [ -n "$DEST_PDF" ]; then    
   echo "Output generated in ${output} and copied to directory ${DEST_PDF}"   
   mv "${output}" "${DEST_PDF}"
else 
   echo "Output generated in ${output}"
fi

popd || exit