#!/usr/bin/env bash

if [ ! -f .env ]; then
    echo "You must provide an ENV file"
fi

source .env

required_vars=("MIX_TARGET" "NERVES_NETWORK_SSID" "NERVES_NETWORK_PSK" "NERVES_DEVICE_NAME" "SECRET_KEY_BASE")

for var in "${required_vars[@]}" 
do
  [ ! -v $var ] && echo "You must set $var." && exit 1;
done

echo "Building $NERVES_DEVICE_NAME!"

cd ui

mix deps.update --all
mix deps.get
mix compile
cd assets
npm install
./node_modules/.bin/webpack --mode production

cd ..

mix phx.digest

cd ../feeder

mix deps.update --all
mix deps.get
mix deps.compile

cd ../firmware

mix deps.update --all
mix deps.get
mix firmware

cd ..