# ===========================
# Stage 1 - Build React App
# ===========================
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files first (better cache)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy project
COPY . .

# Build production files
RUN npm run build

# ===========================
# Stage 2 - Nginx
# ===========================
FROM nginx:stable-alpine

# Copy Vite build output
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]