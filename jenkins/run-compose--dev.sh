export COMPOSE_PROJECT_NAME='test_local_jenkins_dpapi'
docker-compose \
-f docker-compose.dev.yml \
$@