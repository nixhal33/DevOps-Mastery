# Stage 1: Build the Node.js application
FROM node:18-alpine as BUILD

WORKDIR /app

# Copy package.json and vite.config.ts to the container's working directory
COPY package.json .
COPY vite.config.ts .

# Install dependencies and TypeScript
RUN npm install
RUN npm install typescript

# Copy the entire application and build it
COPY . .
RUN npm run build

RUN ls -l && ls -l dist

# Stage 2: Serve the built application using Nginx
FROM nginx:alpine as PROD

# Remove default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Copy build artifacts to Nginx's web root directory
COPY --from=BUILD /app/dist/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
