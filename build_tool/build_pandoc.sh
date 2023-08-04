#!/bin/bash
VERSION="1.0.1"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DIR="."

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hn:" option; do
   case $option in
      n) # Enter a file name
         DIR="$OPTARG"
         ;;
      h) # not yet implemented
      echo "not yet implemented"
      exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
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
output=${input/'.md'/'.pdf'}

pushd "$DIR" || exit

# Creating the document, using XeTex as engine
# We also pass the current script directory path for pandoc to find the template. We also require to pass the toolchain directory for including the image once. For this reason, we pass the location of the directory as a variable (which is not escaped by pandoc, and not as a metadata (which is the same as the values given in the YAML header of the .md))
pandoc "${input}" -o "${output}" --pdf-engine=xelatex --from markdown+tex_math_dollars+raw_tex --template="$SCRIPT_DIR/isc_lab.tex" --listings -V colorlinks --number-sections --variable=TOOLCHAINPATH:"$SCRIPT_DIR" --metadata=DRAFT:false --metadata=GENERATORVERSION:"$VERSION" #--verbose

# cp "${output}" ../pdf/

echo "Output generated in ${output} and copied to PDF directory"
popd || exit