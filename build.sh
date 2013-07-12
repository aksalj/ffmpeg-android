#!/bin/bash

./config.sh

cd ffmpeg

make install -j32

cd ..