# --- Stage 1: Build ---
FROM python:3.11-slim AS builder
WORKDIR /app
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir fastapi uvicorn

# --- Stage 2: Runtime ---
FROM python:3.11-slim AS runtime
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY src/app.py .
ENV PATH="/opt/venv/bin:$PATH"
ENV APP_ENV="production"
EXPOSE 8000
CMD ["python", "app.py"]