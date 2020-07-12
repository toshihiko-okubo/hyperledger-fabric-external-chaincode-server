#!/usr/bin/env bash
set -eux

export FABRIC_CFG_PATH=${PWD}/config

configtxgen \
-profile OrdererGenesis \
-channelID system-channel \
-outputBlock ./artifacts/orderer.block

configtxgen \
-profile Org1MSPSolo \
-channelID org1channel \
-outputCreateChannelTx ./artifacts/org1channel.tx \
-asOrg Org1
