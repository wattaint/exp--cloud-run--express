source _common.sh

export COMPOSE_PROJECT_NAME=$(basename `pwd` | sed 's/-/_/g')_prod_

docker-compose \
-f compose/docker-compose.yml \
-f compose/docker-compose.prod.yml \
$@