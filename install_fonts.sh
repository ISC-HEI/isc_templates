#!/usr/bin/env bash

echo "Installing fonts locally..."

wget https://marcellus.begincoding.net/fonts/modern-isc-fonts.tar.gz

mkdir -p /tmp/modern-isc-fonts
tar -zxvf modern-isc-fonts.tar.gz -C /tmp/modern-isc-fonts

if [[ "$OSTYPE" == "darwin"* ]]; then
    fonts_dir="${HOME}/Library/Fonts"
else
    fonts_dir="${HOME}/.local/share/fonts"
fi

if [ ! -d "${fonts_dir}" ]; then
    echo "mkdir -p $fonts_dir"
    mkdir -p "${fonts_dir}"
else
    echo "Found fonts dir $fonts_dir"
fi

cp /tmp/modern-isc-fonts/*.ttf $fonts_dir    
cp /tmp/modern-isc-fonts/*.otf $fonts_dir    

echo "Rebuilding cache... with fc-cache -f"
fc-cache -f

echo "Cleaning up..."
rm modern-isc-fonts.tar.gz
rm -rf /tmp/modern-isc-fonts
