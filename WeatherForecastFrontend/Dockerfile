FROM node:22.8.0-alpine

WORKDIR /PORTFOLIO

COPY package.json .

RUN npm install

COPY . .

ENV PORT=8080

EXPOSE 8080
# docker build . -t weather-forecast-frontend
CMD [ "serve", "-s", "dist" ]