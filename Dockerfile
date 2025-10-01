FROM ghcr.io/berriai/litellm:main

COPY litellm.config.yaml /app/config.yaml

EXPOSE 4000

CMD ["--host", "0.0.0.0", "--port", "4000", "--config", "/app/config.yaml"]
