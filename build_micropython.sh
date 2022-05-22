#!/bin/bash
rm micropython/ports/esp8266/build-GENERIC/firmware-combined.bin

cd micropython
git pull

cd mpy-cross && make

cd ../ports/esp8266 \
 && make clean \
 && make
