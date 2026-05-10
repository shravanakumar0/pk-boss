FROM node:20-alpine AS builder

WORKDIR /app

COPY server/package.json ./server/
COPY client/package.json ./client/

RUN cd server && npm install
RUN cd client && npm install

COPY . .

RUN cd client && npm run build

FROM node:20-alpine

WORKDIR /app

RUN mkdir -p /app/data

COPY --from=builder /app/server ./server
COPY --from=builder /app/server/node_modules ./server/node_modules
COPY --from=builder /app/client/dist ./client/dist

EXPOSE 5000

CMD ["node", "server/src/index.js"]
