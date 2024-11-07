FROM node:18-alpine AS builder

ARG REACT_APP_BACKEND_URL=http://localhost/api

COPY . /guess_game

COPY package*.json /guess_game

WORKDIR guess_game

RUN npm install

RUN npm run build

FROM nginx:alpine

COPY --from=builder /guess_game/build/ /usr/share/nginx/html/

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]