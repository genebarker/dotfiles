#!/bin/bash

ALACRITTY_FOLDER="$HOME/.config/alacritty"
SCRIPT_FILENAME="$(basename ${BASH_SOURCE})"

usage() {
cat << EOF
NAME
    ${SCRIPT_FILENAME} - an Alacritty iconset maker

SYNOPSIS
    ${SCRIPT_FILENAME} [-dh]

DESCRIPTION
    Download a better set of icons for Alacritty, and create a '.icns'
    icons file for use on MacOS.

OPTIONS
    -d  Download and create new icons file for Alacritty
    -h  Display this help
EOF
}

DOWNLOAD=false

while getopts ":dh" opt; do
    case $opt in
        d) DOWNLOAD=true ;;
        h) usage; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage; exit 1 ;;
    esac
done

if ! $DOWNLOAD; then
    usage
    exit 1
fi

# Create working dir
mkdir -p $ALACRITTY_FOLDER/icons/scanlines.iconset
cd $ALACRITTY_FOLDER/icons/scanlines.iconset
rm -f *

# Download the scanlines icons
curl -LO https://raw.githubusercontent.com/dfl0/mac-icons/main/alacritty/icons/scanlines/alacritty_scanlines_64.png
curl -LO https://raw.githubusercontent.com/dfl0/mac-icons/main/alacritty/icons/scanlines/alacritty_scanlines_128.png
curl -LO https://raw.githubusercontent.com/dfl0/mac-icons/main/alacritty/icons/scanlines/alacritty_scanlines_256.png
curl -LO https://raw.githubusercontent.com/dfl0/mac-icons/main/alacritty/icons/scanlines/alacritty_scanlines_512.png
curl -LO https://raw.githubusercontent.com/dfl0/mac-icons/main/alacritty/icons/scanlines/alacritty_scanlines_full.png

# Map them to Apple’s required names
sips -z 16 16  alacritty_scanlines_64.png  --out icon_16x16.png >/dev/null
sips -z 32 32  alacritty_scanlines_64.png  --out icon_16x16@2x.png >/dev/null
sips -z 32 32  alacritty_scanlines_64.png  --out icon_32x32.png >/dev/null
cp            alacritty_scanlines_64.png            icon_32x32@2x.png
cp            alacritty_scanlines_64.png            icon_64x64.png
cp            alacritty_scanlines_128.png           icon_64x64@2x.png
cp            alacritty_scanlines_128.png           icon_128x128.png
cp            alacritty_scanlines_256.png           icon_128x128@2x.png
cp            alacritty_scanlines_256.png           icon_256x256.png
cp            alacritty_scanlines_512.png           icon_256x256@2x.png
cp            alacritty_scanlines_512.png           icon_512x512.png
cp            alacritty_scanlines_full.png          icon_512x512@2x.png

# Build the .icns
cd ..
iconutil -c icns scanlines.iconset
