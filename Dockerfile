FROM node:16-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --production

COPY . .

# Support both INDEXER_PORT and Cloud Run's PORT
ARG INDEXER_PORT=3003
ENV INDEXER_PORT=${INDEXER_PORT}
# Cloud Run will use PORT if INDEXER_PORT is not set
ENV PORT=${INDEXER_PORT}

# Allow connections from all hosts
EXPOSE ${INDEXER_PORT}

CMD [ "node", "src/index.js" ]