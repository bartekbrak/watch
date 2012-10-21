#!/bin/sh
LOC=/home/bartek/workspace/watch

if [ -z "$(pidof gtk-gnash)" ]
then
    while [ 1 ]; do gtk-gnash ${LOC}/main.swf ; done &
else
    killall gtk-gnash
fi

gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=${LOC}/combined.pdf -dBATCH ${LOC}/pdfs/*.pdf
pdf2swf ${LOC}/combined.pdf -o ${LOC}/main.swf