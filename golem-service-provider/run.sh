#! /bin/bash

export YAGNA_AUTOCONF_APPKEY="q-$RANDOM-$RANDOM"
export YAGNA_APPKEY="$YAGNA_AUTOCONF_APPKEY"
export NETWORK=${NETWORK:-rinkeby}
export DATA_DIR=provider_dir
export PROVIDER_LOG_DIR=provider_dir_logs
export YAGNA_DATADIR=yagna_dir
export SUBNET=${SUBNET:-polygon_proxy}
export NODE_NAME=${NODE_NAME:-polygon_proxy}
export YA_PAYMENT_NETWORK=${NETWORK:-rinkeby}

export HTTPS_PORT=${HTTPS_PORT:-1443}
export HTTP_PORT=${HTTP_PORT:-1180}
export SERVER_NAME=${SERVER_NAME:-bor-proxy-provider}
export TARGET_PROXY=${TARGET_PROXY:-http://51.38.53.113:8545}
export SERVICE_NAME=${SERVICE_NAME:-bor-service}
export SERVICE_DESCRIPTION=${SERVICE_DESCRIPTION:-Bor service}

export MAX_AGREEMENTS=${MAX_AGREEMENTS:-1}
export MIN_AGREEMENT_EXPIRATION=${MIN_AGREEMENT_EXPIRATION:-5s}

sed -i 's/%%HTTPS_PORT%%/'$HTTPS_PORT'/g' plugins/ya-runtime-bor/services/bor-service-template.txt
sed -i 's/%%HTTP_PORT%%/'$HTTP_PORT'/g' plugins/ya-runtime-bor/services/bor-service-template.txt
sed -i 's/%%SERVER_NAME%%/'$SERVER_NAME'/g' plugins/ya-runtime-bor/services/bor-service-template.txt
sed -i 's#%%TARGET_PROXY%%#'$TARGET_PROXY'#g' plugins/ya-runtime-bor/services/bor-service-template.txt
sed -i 's#%%SERVICE_NAME%%#'$SERVICE_NAME'#g' plugins/ya-runtime-bor/services/bor-service-template.txt
sed -i 's#%%SERVICE_DESCRIPTION%%#'$SERVICE_DESCRIPTION'#g' plugins/ya-runtime-bor/services/bor-service-template.txt
cp plugins/ya-runtime-bor/services/bor-service-template.txt plugins/ya-runtime-bor/services/bor-service.json

./yagna service run &
sleep 5
./yagna id list
./yagna payment init --receiver --driver erc20 --network $NETWORK
./ya-provider run --max-simultaneous-agreements $MAX_AGREEMENTS --min-agreement-expiration $MIN_AGREEMENT_EXPIRATION

sleep 30

