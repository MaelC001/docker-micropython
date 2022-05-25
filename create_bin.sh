cd /micropython && git pull

cd ./mpy-cross && make

cd ../ports/esp8266 \
   && make clean \
   && make