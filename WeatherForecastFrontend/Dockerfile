FROM node:22.8.0-alpine

WORKDIR /react

COPY package.json .


COPY . .
RUN npm install
RUN npm run build
RUN npm i -g serve


ENV PORT=8080

EXPOSE 8080
CMD [ "serve", "-s", "dist", "-p", "8080" ]