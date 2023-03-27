# golem-rpc-provider

# Deployment

## Build image locally

WARNING: This can take significant amount of time

```
docker build -t golem.network/provider/bor ./golem_service_provider
ansible-playbook ansible/localbuild.yaml
```

## Deploy on providers.gateway

```
ansible-playbook -i inventory.yaml ansible/deployment.yaml
```

## Check logs

```
ssh ubuntu@providers.gateway.golem.network
docker-compose -p borprov logs provider_<provider index number as in docker-compose.yml>
```
