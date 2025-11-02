#!/usr/bin/env bash

# --- TUNABLE PARAMETERS ---
LOG_FILE="${LOG_FILE-/var/log/kern.log}"
TIME_RANGE="-l 1d"
MAX_ENTRIES="-M 50"
INTERFACE_FILTER="wan-localhost"
# --------------------------

grep "${INTERFACE_FILTER}" "${LOG_FILE}" |
  fwlogwatch \
    "${TIME_RANGE}" \
    -n \
    -N \
    "${MAX_ENTRIES}" \
    -p \
    -d \
    - |
  batcat \
    --paging=never \
    -l log
