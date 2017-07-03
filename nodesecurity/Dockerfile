FROM node:8-alpine

RUN yarn global add nsp

WORKDIR /app
VOLUME /app

CMD ["nsp", "check", "-o", "summary"]
