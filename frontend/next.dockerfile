# frontend/Dockerfile
FROM node:18-alpine AS base

WORKDIR /app

# Install dependencies
COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --frozen-lockfile

# Copy the rest of your application code
COPY . .

# Build the application
RUN npm run build

# Production image
FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=base /app/next.config.js ./
COPY --from=base /app/public ./public
COPY --from=base /app/.next/standalone ./
COPY --from=base /app/.next/static ./.next/static

ENV NODE_ENV=production
ENV PORT=3000
CMD ["node", "server.js"]
