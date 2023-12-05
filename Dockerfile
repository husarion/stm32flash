FROM ubuntu:18.04 AS stm32flash_builder

SHELL ["/bin/bash", "-c"]

WORKDIR /stm32flash
# official releases are only for intel archs, so we need to build stm32flash from sources
COPY . .

RUN apt-get update && apt-get install -y \
		curl \
		git \
		build-essential \
		cmake && \
	make all

CMD ARCH=$(uname -m); \
    if [ "$ARCH" = "aarch64" ]; then \
        cp /stm32flash/stm32flash /output/stm32flash-arm64; \
    elif [ "$ARCH" = "x86_64" ]; then \
        cp /stm32flash/stm32flash /output/stm32flash-amd64; \
    else \
        echo "Unsupported architecture: $ARCH"; \
        exit 1; \
    fi
