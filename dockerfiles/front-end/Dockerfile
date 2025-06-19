# Use the official image as base
FROM weaveworksdemos/front-end:0.3.12 as original

# Create a new minimal image with security hardening
FROM node:18-alpine

# Create non-root user
RUN addgroup -g 10001 appgroup && \
    adduser -u 10001 -G appgroup -s /bin/sh -D appuser

# Set working directory
WORKDIR /usr/src/app

# Copy application from the official image
COPY --from=original --chown=appuser:appgroup /usr/src/app /usr/src/app

# Set environment variables
ENV NODE_ENV="production" \
    USER_DIR="/tmp" \
    PORT=8079

# Expose application port
EXPOSE 8079

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q -O- http://localhost:8079/health || exit 1

# Run the application
CMD ["npm", "start"] 