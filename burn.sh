#!/usr/bin/env bash

source build.sh

cd firmware

mix firmware.burn

cd ..