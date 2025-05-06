# Étape de base : image Node avec pnpm
FROM node:22-slim AS base

# Installer pnpm proprement via npm
RUN npm install -g pnpm

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers
COPY . .

# Étape 1 : Installer les dépendances de prod
FROM base AS prod-deps
RUN pnpm install --prod --frozen-lockfile

# Étape 2 : Build de l'application
FROM base AS build
RUN pnpm install --frozen-lockfile
RUN pnpm run build

# Étape finale : exécutable
FROM base

# Copier la build et les node_modules
COPY --from=build /app/dist /app/dist
COPY --from=prod-deps /app/node_modules /app/node_modules

# Copier le script d'entrée
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

# Installer git (si nécessaire pour des dépendances ou du clone runtime)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Rendre le script exécutable et corriger les fins de lignes
RUN chmod +x /app/docker-entrypoint.sh \
    && sed -i 's/\r$//' /app/docker-entrypoint.sh

# Exposer le port utilisé par Firecrawl (3002 par défaut)
EXPOSE 3002

# Utiliser le script comme point d’entrée
ENTRYPOINT ["/app/docker-entrypoint.sh"]
