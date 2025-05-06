#!/bin/bash -e

# Affiche l'utilisateur courant
if [ "$UID" -eq 0 ]; then
  echo "ENTRYPOINT is running as root"
  ulimit -n 65535
  echo "NEW ULIMIT: $(ulimit -n)"
else
  echo "ENTRYPOINT did not run as root"
fi

# Choix du processus selon la variable PROCESS_TYPE
if [ "$PROCESS_TYPE" = "api" ]; then
  echo "RUNNING Firecrawl API"
  node --max-old-space-size=8192 dist/src/index.js
elif [ "$PROCESS_TYPE" = "worker" ]; then
  echo "RUNNING Firecrawl Worker"
  node --max-old-space-size=8192 dist/src/services/queue-worker.js
elif [ "$PROCESS_TYPE" = "index-worker" ]; then
  echo "RUNNING Indexing Worker"
  node --max-old-space-size=8192 dist/src/services/indexing/index-worker.js
else
  echo "NO VALID PROCESS_TYPE PROVIDED - running default API"
  node --max-old-space-size=8192 dist/src/index.js
fi
