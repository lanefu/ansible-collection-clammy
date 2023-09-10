#!/usr/bin/env bash

awk '{if ($1) {$1=strftime("%c",$1); print}}' /var/lib/misc/dnsmasq.leases | sort
