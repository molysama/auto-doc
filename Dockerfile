FROM node:12
LABEL description="A demo Dockerfile for build Docsify."
WORKDIR /docs
COPY . /docs
RUN npm install -g docsify-cli@latest
EXPOSE 3000/tcp
ENTRYPOINT docsify serve .