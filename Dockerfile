FROM node:23-alpine3.21 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm i
COPY . .
RUN npm run build

FROM caddy:2.9.1-alpine
COPY --from=builder /app/build /usr/share/caddy
