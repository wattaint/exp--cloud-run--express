FROM node:10.15.3-stretch
RUN apt-get update && apt-get -y install \
  vim \
  && apt-get clean && \
  rm -r /var/lib/apt/lists/*

ENV PATH $PATH:/node_modules/.bin

RUN npm install -g npm@6.9.0
COPY package.json package-lock.json /
RUN npm install && pm2 install coffeescript

COPY . /app
WORKDIR /app

CMD [ "pm2-docker", "/app/process.yml" ]
RUN echo "set mouse-=a" > ~/.vimrc