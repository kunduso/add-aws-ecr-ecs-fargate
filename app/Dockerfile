# Test web app that returns the name of the host/pod/container servicing req
# Linux x64
FROM node:current-alpine

LABEL org.opencontainers.image.title="Hello Docker Learners!" \
      org.opencontainers.image.description="Web server showing host that responded" \
      org.opencontainers.image.authors="@kunduso"

# Create directory in container image for app code
RUN mkdir -p /usr/src/app

# Copy app code (.) to /usr/src/app in container image
COPY ./app /usr/src/app

# Set working directory context
WORKDIR /usr/src/app

# Install dependencies from packages.json
RUN npm install

# Install curl for healthcheck
RUN apk --no-cache add curl
# Add health check
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f http://localhost:8080 || exit 1

# Create a new user
RUN adduser -D myuser

# Switch to the new user
USER myuser


# Command for container to execute
ENTRYPOINT [ "node", "app.js" ]