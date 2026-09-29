# Backend HabitaNexus (Nest 12 + SWC + Prisma 7). Build de la imagen usada
# por k8s/base (ghcr.io/habitanexus/monorepo/backend) y por el smoke en minikube.
# Requiere DATABASE_URL en build (solo para `prisma generate`, no conecta)
# y en runtime (PrismaService hace $connect en onModuleInit).
FROM node:22-slim AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY prisma ./prisma
COPY prisma.config.ts ./
COPY src ./src
COPY nest-cli.json tsconfig.json tsconfig.build.json .swcrc ./
ARG DATABASE_URL="postgresql://localhost:5432/postgres"
ENV DATABASE_URL=${DATABASE_URL}
RUN npx prisma generate
RUN npm run build

FROM node:22-slim AS runtime
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund
COPY --from=build /app/dist ./dist
COPY --from=build /app/generated ./generated
COPY --from=build /app/node_modules/.prisma ./node_modules/.prisma
EXPOSE 3000
CMD ["node", "dist/src/main.js"]
