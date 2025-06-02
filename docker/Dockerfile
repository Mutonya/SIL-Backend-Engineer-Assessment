# Build stage
FROM python:3.10-slim as builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements /requirements
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r /requirements/production.txt

# Final stage
FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq5 curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/wheels /wheels
COPY --from=builder /requirements /requirements

RUN pip install --no-cache /wheels/* && \
    useradd -m django && \
    chown -R django /app
ENV PYTHONPATH=/app:/app/apps
USER django

COPY --chown=django . .

EXPOSE 8000

ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "ecommerce.wsgi:application"]
