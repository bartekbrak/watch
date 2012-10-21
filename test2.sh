#!/bin/sh
set -e # abort if anything goes wrong
xsetroot -solid white

SWF_FPS=2
LOC=/home/bartek/workspace/watch
SWF_FILENAME=pdfprojector.swf
LAUNCH="gtk-gnash -r 1 -d 1 --fullscreen ${SWF_FILENAME}"

${LAUNCH} &

while inotifywait -e modify ${LOC}/pdfs/ ; do
    echo -e "\n" >> ${LOC}/log
    date '+[%Y-%m-%d %T] pdfs dir content changed, recreating swf' >> ${LOC}/log
    # the screen capture does not alway work
    #import -descend -window pdfprojector.swf wallpaper_screenshot.jpg >> ${LOC}/log
    #display -window root wallpaper_screenshot.jpg >> ${LOC}/log
    gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=${LOC}/combined.pdf -dBATCH ${LOC}/pdfs/*.pdf >> ${LOC}/log
    pdf2swf ${LOC}/combined.pdf -o ${LOC}/${SWF_FILENAME} -s framerate=${SWF_FPS} >> ${LOC}/log
    killall gtk-gnash >> ${LOC}/log
    ${LAUNCH} & >> ${LOC}/log
    date '+[%Y-%m-%d %T] swf created, wallpapers swapped, player reinitialized with new content' >> ${LOC}/log
done

# http://stackoverflow.com/questions/12933849/make-a-program-reload-an-already-opened-file-on-file-change