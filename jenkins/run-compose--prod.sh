export COMPOSE_PROJECT_NAME='test_local_jenkins_dpapi_prod_'
docker-compose \
-f compose/docker-compose.yml \
-f compose/docker-compose.prod.yml \
$@