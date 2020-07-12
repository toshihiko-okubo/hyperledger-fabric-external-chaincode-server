#!/bin/bash
# Copyright London Stock Exchange Group All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
set -eux

CHANNEL_NAME=org1channel

echo "### Creating channel ${CHANNEL_NAME}"
peer channel create -c ${CHANNEL_NAME} -f ./artifacts/${CHANNEL_NAME}.tx -o orderer.dev.com:7050
peer channel join -b ./${CHANNEL_NAME}.block  -o orderer.dev.com:7050
echo "### Creating channel ${CHANNEL_NAME} Done"

sleep 600000
exit 0
