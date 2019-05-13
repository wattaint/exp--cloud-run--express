FROM google/cloud-sdk:245.0.0-alpine
RUN gcloud components install beta

COPY deploy.sh /deploy.sh
RUN chmod +x /deploy.sh
CMD [ "/deploy.sh" ]