FROM node:22-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier directement les fichiers du projet
COPY . .

# Étape prod-deps
FROM node:22-slim AS prod-deps
RUN npm install -g pnpm
WORKDIR /app
COPY apps/api/package.json ./ 
COPY apps/api/pnpm-lock.yaml ./
RUN pnpm install --prod --frozen-lockfile

# Étape build
FROM node:22-slim AS build
RUN npm install -g pnpm
WORKDIR /app
COPY apps/api/ ./
RUN pnpm install --frozen-lockfile
RUN pnpm run build

# Étape finale
FROM node:22-slim AS final
RUN npm install -g pnpm
WORKDIR /app

COPY --from=build /app/dist /app/dist
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY apps/api/docker-entrypoint.sh /app/docker-entrypoint.sh

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
RUN chmod +x /app/docker-entrypoint.sh && sed -i 's/\r$//' /app/docker-entrypoint.sh

EXPOSE 3002
ENTRYPOINT ["/app/docker-entrypoint.sh"]
