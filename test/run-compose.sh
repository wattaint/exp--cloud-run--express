export IMAGE_NAME=test-cloud-checking
export COMPOSE_PROJECT_NAME=$(basename `pwd` | sed 's/-/_/g')_test_

docker-compose \
-f docker-compose.dev.yml \
$@