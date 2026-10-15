FROM node:22-bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg libheif-examples openssl ca-certificates && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@11.25.0 --activate
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml tsconfig.base.json ./
COPY services/api/package.json services/api/package.json
COPY services/worker/package.json services/worker/package.json
COPY packages/database/package.json packages/database/package.json
COPY packages/contracts/package.json packages/contracts/package.json
COPY packages/sdk-ts/package.json packages/sdk-ts/package.json
COPY apps/web/package.json apps/web/package.json
RUN pnpm --filter @pixel8/worker... --filter pixel8 install --frozen-lockfile --store-dir=/tmp/pixel8-pnpm-store \
    && rm -rf /tmp/pixel8-pnpm-store
COPY services services
COPY packages packages
COPY scripts scripts
RUN DATABASE_URL=postgresql://build:build@localhost/build pnpm --filter @pixel8/database db:generate
RUN pnpm --filter @pixel8/worker... build
ENV NODE_ENV=production
CMD ["pnpm", "--filter", "@pixel8/worker", "start"]
