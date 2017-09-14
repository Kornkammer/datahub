FROM node:8.5.0

RUN npm install -g coffeescript
RUN npm install -g nodemon

EXPOSE 4444

USER node
WORKDIR app

CMD nodemon index.coffee
