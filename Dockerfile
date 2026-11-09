# epanet-js (variante fond OSM, sans token) — build + run token-free.
# Usage:
#   docker build -t epanet-osm .
#   docker run --rm -p 3000:3000 epanet-osm
# Puis ouvrir http://localhost:3000
#
# Les secrets éventuels (Mapbox, Clerk…) peuvent être fournis au run
# via -e ; l'app démarre sans eux (fond OSM, mode local).

FROM node:24-bookworm AS builder

# Toolchain requise par `canvas` (cf. README).
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 make g++ \
    libpixman-1-dev libcairo2-dev libpango1.0-dev libgif-dev \
  && rm -rf /var/lib/apt/lists/*

RUN corepack enable && corepack prepare pnpm@9.15.9 --activate

WORKDIR /app

# Manifestes d'abord (cache Docker), install déterministe via le lockfile.
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./
COPY apps/app/package.json apps/app/package.json
COPY libs/buffers/package.json libs/buffers/package.json
COPY libs/change-set/package.json libs/change-set/package.json
COPY libs/converters/package.json libs/converters/package.json
COPY libs/ejsdb/package.json libs/ejsdb/package.json
COPY libs/ejsdb-mappers/package.json libs/ejsdb-mappers/package.json
COPY libs/ejsdb-tag/package.json libs/ejsdb-tag/package.json
COPY libs/elevations/package.json libs/elevations/package.json
COPY libs/geometry/package.json libs/geometry/package.json
COPY libs/gis-importers/package.json libs/gis-importers/package.json
COPY libs/hydraulic-model/package.json libs/hydraulic-model/package.json
COPY libs/i18n/package.json libs/i18n/package.json
COPY libs/id-generator/package.json libs/id-generator/package.json
COPY libs/map/package.json libs/map/package.json
COPY libs/model-schema/package.json libs/model-schema/package.json
COPY libs/project-settings/package.json libs/project-settings/package.json
COPY libs/projections/package.json libs/projections/package.json
COPY libs/quantity/package.json libs/quantity/package.json
COPY libs/simulation/package.json libs/simulation/package.json
COPY libs/ui-kit/package.json libs/ui-kit/package.json
COPY libs/worktree/package.json libs/worktree/package.json

RUN pnpm install --frozen-lockfile

# Sources puis build Next.js (inclut le prebuild : wasm + assets des libs).
COPY . .
ENV NEXT_PUBLIC_MAPBOX_TOKEN=_ \
    NEXT_PUBLIC_GEOCODE_EARTH_TOKEN=_ \
    NEXT_PUBLIC_SKIP_USER_TRACKING=true
RUN pnpm --filter @epanet-js/app build

FROM node:24-bookworm-slim AS runner
ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 3000
CMD ["pnpm", "--filter", "@epanet-js/app", "start"]
