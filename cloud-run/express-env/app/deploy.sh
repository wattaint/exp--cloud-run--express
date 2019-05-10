#!/bin/bash

source _common.sh

gcloud beta run deploy \
exp-cloud-run--express \
--region us-central1 \
--project dataplatform-1363 \
--image us.gcr.io/dataplatform-1363/${IMAGE_BASE_NAME}:dev \
--update-env-vars IAP_TARGET_AUDIENCE="863016118673-08v4207jrjsh5jum70404bqq1u3keig4.apps.googleusercontent.com"