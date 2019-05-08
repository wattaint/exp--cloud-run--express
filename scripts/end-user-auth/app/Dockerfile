FROM node:10.15.3-stretch

ENV PATH $PATH:/node_modules/.bin

COPY package.json package-lock.json /
RUN npm install

WORKDIR /app