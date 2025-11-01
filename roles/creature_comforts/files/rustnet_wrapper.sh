#!/usr/bin/env bash

# FIXME: we shouldnt need SYS_ADMIN capability... but we do for eBPF to work interpreter_discovery
# the docs disagree

sudo podman run --rm -it \
  --cap-add=SYS_ADMIN \
  --cap-add=BPF \
  --cap-add=PERFMON \
  --cap-add=NET_RAW \
  --net=host \
  ghcr.io/domcyrus/rustnet:latest ${@}
