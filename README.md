# Ansible Collection - lanefu.clammy

roles, plugins, etc for [clammy-ng linux based router config](https://github.com/lanefu/clammy-ng)

The preference is to use off-the-shelf roles.  This repo contains custom roles, and some forks of roles with bug fixes.
They may be removed as bugfixes are upstreamed.

## filters

interface_by_zone -- used for parsing foomuuri_networks into pleasant format

## roles

### custom

readme's need to be updated.  please view tasks and defaults for now.

* creature_comforts -- extra packages and scripts for router related things in user space
* foomuuri -- install, configure, manage, foomuuri zone-based-firewall for nftables
* sanatize_armbian_defaults -- adjustments meant for armbian based systems
* sysctl_base -- enable ip forwarding etc

### forks

Huge shoutout to mrlesmithjr.  His roles are awesome.  I've sent tweaks back to him. some have been accepted.

* dnsmasq -- mrlesmithjr's dnsmasq
* frr -- mrlesmithjr's frrouting 
* netplan -- mrlesmithjr's netplan roles
* inadyn -- mivek's inadyn dynamic dns client role
