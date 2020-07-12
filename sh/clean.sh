#!/usr/bin/env bash

set -eux pipefail

docker-compose down --volumes --remove-orphans

rm -rf ./artifacts/*.block ./artifacts/*.tx
rm -rf ./*.block
rm -rf ./*.tar.gz
rm -rf ./*-ccid.txt
