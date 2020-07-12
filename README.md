# hyperledger-fabric-external-chaincode-server
This repository is an example of running chaincode in the Local environment

## Requirement
- golang 1.14
- docker
- docker-compose

## Usage
1. To launch the chain
```bash
$ make start
``` 

2. To call the chaincode function
```bash
$ make initChainCode
$ make invokeChainCode
$ make queryChainCode
```

## Ref
- https://hyperledger-fabric.readthedocs.io/en/release-2.1/cc_service.html
- https://github.com/vanitas92/fabric-external-chaincodes
