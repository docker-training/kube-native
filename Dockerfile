FROM node:8.10.0

WORKDIR /usr/src/app
COPY package.json .
RUN npm install
RUN npm install nodemon -g
COPY . .

CMD ["nodemon", "server.js"]
