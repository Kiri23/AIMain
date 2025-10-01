# syntax=docker/dockerfile:1
FROM node:20-slim

# Install the minimal Python toolchain required for LiteLLM while leaving Node.js
# available for any future experiments.
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip python3-venv build-essential \
    && rm -rf /var/lib/apt/lists/*

# Ensure the `python` and `pip` commands are available for convenience.
RUN ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

# Set working directory for the LiteLLM proxy.
WORKDIR /app

# Install LiteLLM with the proxy extras to ensure the server CLI is available.
RUN python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir "litellm[proxy]"

# Copy the default configuration file into the image. Users can override
# this at runtime by mounting their own config file.
COPY litellm.config.yaml /app/config.yaml

# Expose the default port used by the LiteLLM proxy.
EXPOSE 4000

# Start the LiteLLM proxy using the bundled configuration file.
CMD ["litellm", "--host", "0.0.0.0", "--port", "4000", "--config", "/app/config.yaml"]
