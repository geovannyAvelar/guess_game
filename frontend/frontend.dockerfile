FROM node:18-alpine AS builder

COPY . /guess_game

COPY package*.json /guess_game

WORKDIR guess_game

RUN npm install

RUN npm run build

FROM nginx:alpine

COPY --from=builder /guess_game/* /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]