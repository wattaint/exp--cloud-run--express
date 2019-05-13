#!/bin/bash

gcloud beta run deploy \
exp-cloud-run--dpapi \
--region us-central1 \
--project dataplatform-1363 \
--image us.gcr.io/dataplatform-1363/acm.dp.dataplatform-api \
--memory=2Gi \
--update-env-vars \
IAP_TARGET_AUDIENCE="863016118673-08v4207jrjsh5jum70404bqq1u3keig4.apps.googleusercontent.com"\
,SPRING_APPLICATION_NAME="dpapi--cloud-run--dev"\
,SPRING_ADMIN_URL="https://dpapi-admin.ascendanalyticshub.com"\
,JENKINS_URL="https://dpapi-staging-dp.ascendanalyticshub.com"\
,JENKINS_USER="admin"\
,JENKINS_API_TOKEN="11d1c1555184e1b1da665e4efc5225563c"\
,CLIENT_TAG_ENV="DEV"\
,CLIENT_TAG_COUNTRY="TH"\
,CLIENT_TAG_URL="https://dpapi-vn.ascendanalyticshub.com/swagger-ui.html"\
,DPAPI_API_TOKEN="0bf97503-802a-4b72-9ec1-0f12c635ba3a"
