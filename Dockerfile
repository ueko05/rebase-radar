FROM python:3.12-slim

WORKDIR /app

COPY rebase-radar-v0.3.zip /tmp/rebase-radar-v0.3.zip

RUN python -c "import zipfile; zipfile.ZipFile('/tmp/rebase-radar-v0.3.zip').extractall('/tmp/src')" \
    && cp -a /tmp/src/rebase-radar-v1/. /app/ \
    && pip install --no-cache-dir . \
    && mkdir -p /data \
    && rm -rf /tmp/src /tmp/rebase-radar-v0.3.zip

ENV RADAR_DB=/data/radar.db \
    RADAR_CONFIG=/app/config/targets.yaml \
    RADAR_MAX_CONCURRENCY=8

EXPOSE 8080

CMD ["/bin/sh", "-c", "exec uvicorn radar.api:app --host 0.0.0.0 --port ${PORT:-8080}"]
