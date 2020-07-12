IMAGE_TAG?=2.1.1
DOCKER=docker
DOCKER_COMPOSE?=docker-compose
LOCAL_HOST_IP=$(shell ifconfig en0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | awk '{print $1}')

CHAINCODE_ADDRESS=0.0.0.0:20000

.PHONY: cryptogen
cryptogen:
	rm -rf ./artifacts
	docker run --rm \
	--workdir="/root" \
	--volume $(CURDIR)/config:/root/config \
	--volume $(CURDIR)/organizations:/root/organizations \
	hyperledger/fabric-tools:${IMAGE_TAG} \
	bash -c "cryptogen generate --config ./config/crypto-config.yaml --output /root/organizations"

.PHONY: initChain
initChain:
	rm -rf ./artifacts
	docker run --rm \
	--workdir="/root/fabric" \
	--volume $(CURDIR):/root/fabric \
	hyperledger/fabric-tools:${IMAGE_TAG} \
	bash -c "./sh/initChain.sh"

.PHONY: up
up:
	LOCAL_HOST_IP=$(LOCAL_HOST_IP) IMAGE_TAG=$(IMAGE_TAG) docker-compose up -d

.PHONY: down
down:
	./sh/clean.sh

.PHONY: deploy
deploy:
	$(DOCKER_COMPOSE) exec cli bash -c "./sh/deploy.sh"

.PHONY: run
run:
	CHAINCODE_CCID=$(shell cat ccid.txt) CHAINCODE_ADDRESS=$(CHAINCODE_ADDRESS) make -C chaincode/abstore run

.PHONY: start
start: down initChain up
	sleep 10
	make deploy
	sleep 3
	make run

CLI=docker-compose exec cli /bin/bash -c
.PHONY: initChainCode
initChainCode:
	$(CLI) "peer chaincode invoke -o orderer.dev.com:7050 -C org1channel -n abstore -c '{\"Args\":[\"init\", \"a\", \"1000\", \"b\", \"100\"]}'"

.PHONY: invokeChainCode
invokeChainCode:
	$(CLI) "peer chaincode invoke -o orderer.dev.com:7050 -C org1channel -n abstore -c '{\"Args\":[\"invoke\", \"a\", \"b\", \"100\"]}'"

.PHONY: queryChainCode
queryChainCode:
	$(CLI) "peer chaincode query -o orderer.dev.com:7050 -C org1channel -n abstore -c '{\"Args\":[\"query\", \"a\"]}'"

