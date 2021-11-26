FROM nixos/nix

# Ruby cannot find nix's tzdata files
RUN apk update && \
    apk add tzdata

RUN adduser -D -u 1000 appuser && \
    chown -R appuser:appuser /nix

USER 1000:1000
