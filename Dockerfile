# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app

# Copy package files FIRST — this layer is cached unless package.json changes
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Build / Test
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm test

# Stage 3: Production Image
FROM node:20-alpine AS production
WORKDIR /app

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/app.js ./app.js
COPY --from=build /app/server.js ./server.js

USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "server.js"]

