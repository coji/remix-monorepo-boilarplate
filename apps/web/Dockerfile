# base node image
ARG NODE_VERSION=18.16.0
FROM node:${NODE_VERSION}-slim as base
ARG SCOPE
LABEL fly_launch_runtime="Remix"

RUN corepack enable \
 && corepack prepare pnpm@8.5.1 --activate \
 && pnpm add -g turbo

WORKDIR /app
COPY . .

FROM base as setup
COPY pnpm-lock.yaml ./

RUN turbo prune --scope=web --docker \
 && pnpm fetch

# Setup production node_modules
FROM base as production-deps
WORKDIR /app

COPY --from=deps /app/node_modules /app/node_modules
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --offline --frozen-lockfile --prod


# Build the app
FROM base as build

WORKDIR /app

COPY --from=deps /app/node_modules /app/node_modules
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --offline --frozen-lockfile

COPY prisma .
RUN pnpm exec prisma generate

COPY . .
RUN pnpm run build


# Run the app
FROM base

ENV NODE_ENV "production"
WORKDIR /app

COPY --from=production-deps /app/package.json /app/package.json
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/tsconfig.json /app/tsconfig.json
COPY --from=build /app/prisma /app/prisma
COPY --from=build /app/build /app/build
COPY --from=build /app/public /app/public

COPY --from=build /app/app /app/app

CMD ["pnpm", "start"]
