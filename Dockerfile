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


FROM ubuntu:14.04

ARG VERSION=master

RUN apt-get update \
    && apt-get install -y make unrar-free autoconf automake libtool gcc g++ gperf \
    flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python python-serial \
    sed git unzip bash help2man wget bzip2 tar xz-utils

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Creating a user, as ng-cross cannot be built as root.
RUN useradd --no-create-home micropython


# long commande, for modul g++
#RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
#RUN chown -R micropython:micropython ../esp-open-sdk

COPY ./tarballs/esp-open-sdk.tar.xz_part00 .
COPY ./tarballs/esp-open-sdk.tar.xz_part01 .
COPY ./tarballs/esp-open-sdk.tar.xz_part02 .
RUN cat esp-open-sdk.tar.xz_part* > esp-open-sdk.tar.xz \
    && tar xf esp-open-sdk.tar.xz \
    && rm esp-open-sdk.tar.xz_part* \
    && rm esp-open-sdk.tar.xz  \
    && chown -R micropython:micropython ../esp-open-sdk

USER micropython

RUN mkdir -p esp-open-sdk/crosstool-NG/.build/tarballs/
COPY ./tarballs/expat-2.1.0.tar.gz esp-open-sdk/crosstool-NG/.build/tarballs/
COPY ./tarballs/isl-0.14.tar.gz esp-open-sdk/crosstool-NG/.build/tarballs/

RUN cd esp-open-sdk && make STANDALONE=y
ENV PATH=/esp-open-sdk/xtensa-lx106-elf/bin:$PATH

USER root

# for micropython perso
RUN git clone https://github.com/MaelC001/micropython.git \
# RUN git clone https://github.com/micropython/micropython.git
    && cd micropython \
    && git checkout $VERSION \
    && git submodule update --init
RUN chown -R micropython:micropython ../micropython

USER micropython

COPY .build_micropython.sh .

RUN bash build_micropython.sh
