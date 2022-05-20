# Copyright (C) 2021  Alessandro Santoni
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


TAG='docker-micropython-esp8266'

docker build -t $TAG .

CONTAINER_ID=$(docker create $TAG)

if [ -z "$1" ]; then
    docker cp $CONTAINER_ID':micropython/ports/esp8266/build-GENERIC/firmware-combined.bin' ./esp8266_micropython_build.bin
else
    docker cp $CONTAINER_ID':micropython/ports/esp8266/build-GENERIC/firmware-combined.bin' ./esp8266_micropython_build_$1.bin
fi

docker rm $CONTAINER_ID
# Commenting lines below will result in faster builds at the expenses of memory usage.
docker image prune -af
docker volume prune -f