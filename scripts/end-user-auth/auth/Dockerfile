FROM node:10.15.3-stretch

RUN apt-get update && apt-get -y install \
  vim \
  && apt-get clean && \
  rm -r /var/lib/apt/lists/*

ENV PATH $PATH:/node_modules/.bin

COPY package.json package-lock.json /
RUN npm install

WORKDIR /auth