
# 1. Builder image for dependencies and compilation
FROM python:3.12-slim-bookworm as builder

WORKDIR /app

# Copy only requirements file initially for caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 2: Final image
FROM python:3.12-slim-bookworm

# Create a non-root user
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Copy dependencies from builder image
COPY --from=builder /root/.cache/pip /root/.cache/pip
COPY --from=builder /app /app

# Copy source code
COPY . .

# Change ownership to the non-root user
RUN chown -R appuser:appuser /app

USER appuser

# Expose the port your application uses
EXPOSE 8000

# Command to run the application
CMD ["python", "main.py"]
