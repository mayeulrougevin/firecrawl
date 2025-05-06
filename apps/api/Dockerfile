FROM node:22-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Installer pnpm
RUN npm install -g pnpm

# Définir le répertoire de travail
WORKDIR /app

# Copier tous les fichiers du dossier actuel (apps/api)
COPY . .

# Étape prod-deps
FROM base AS prod-deps
WORKDIR /app
COPY . .
RUN pnpm install --prod --frozen-lockfile

# Étape build
FROM base AS build
WORKDIR /app
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm run build

# Étape finale
FROM base
WORKDIR /app
COPY --from=build /app/dist /app/dist
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

# Installer git (utile à runtime dans certains cas)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Rendre le script exécutable
RUN chmod +x /app/docker-entrypoint.sh && sed -i 's/\r$//' /app/docker-entrypoint.sh

# Exposer le port
EXPOSE 3002

ENTRYPOINT ["/app/docker-entrypoint.sh"]
