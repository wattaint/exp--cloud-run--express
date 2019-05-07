export IMAGE_NAME=test-cloud-run-by-scripts
export COMPOSE_PROJECT_NAME=$(basename `pwd` | sed 's/-/_/g')_scripts_app_

docker-compose \
-f docker-compose.dev.yml \
$@