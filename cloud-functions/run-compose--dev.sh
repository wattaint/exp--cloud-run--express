export IMAGE_NAME=test-cloud-run-by-functions
export COMPOSE_PROJECT_NAME=$(basename `pwd` | sed 's/-/_/g')_

docker-compose \
-f docker-compose.dev.yml \
$@