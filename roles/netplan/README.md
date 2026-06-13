<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents** _generated with [DocToc](https://github.com/thlorenz/doctoc)_

- [ansible-netplan](#ansible-netplan)
  - [Requirements](#requirements)
  - [Role Variables](#role-variables)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [License](#license)
  - [Author Information](#author-information)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# ansible-netplan

An [Ansible](https://www.ansible.com) role to manage [Netplan](https://netplan.io)

## Requirements

You probably want to run the role with `become: true`

## Role Variables

[defaults/main.yml](defaults/main.yml)

## Dependencies

## Example Playbook

The following is a trivial example of a playbook that sets a single
network interface.  See defaults/main.yml for a full list of values
that can be set for this role.

```yaml
---
- hosts: ...your hosts...
  any_errors_fatal: true
  roles:
    - role: mrlesmithjr.netplan
      become: yes
      # This role will do nothing unless netplan_enabled is true.
      netplan_enabled: true
      
      # This should point to an existing netplan configuration file 
      # on your system which this role will overwrite, 
      # or to a nonexistent file which netplan is aware of.
      #
      # The default is /etc/netplan/config.yaml.
      netplan_config_file: /etc/netplan/my-awesome-netplan.yaml
      
      # Ubuntu 18.04, for example, defaults to using networkd.
      netplan_renderer: networkd
      # Simple network configuration to add a single network interface.
      # Configuration defined bellow will be written to the file defined
      # above in `netplan_config_file`.
      netplan_configuration:
        network:
          version: 2
          ethernets:
            enp28s0f7:
              addresses:
                - 10.11.12.99/24
```
## Using vaulted variables
Vault encrypted variables need to be defined outside the `netplan_configuration` variable to be evaluated.

```yaml
netplan_configuration:
  network:
    version: 2
    tunnels:
      wg_test:
        mode: wireguard
        key: "{{ my_wireguard_private_key }}"
      ....

my_wireguard_private_key: !vault |
          31366530666465373834386563636465636135323562303866363333333865376330303130363162
          ....
```

## License

MIT

## systemd-networkd drop-ins

Use `netplan_networkd_dropins` for networkd features that Netplan does not
expose. Keys are Netplan device IDs; the role derives and verifies the
generated `10-netplan-<ID>.network` filename.

```yaml
netplan_networkd_dropins:
  wan:
    dropins:
      - name: 50-dhcpv6-pd.conf
        content: |
          [DHCPv6]
          PrefixDelegationHint=::/56
```

The role runs `netplan generate`, requires the generated unit to exist,
removes only obsolete files listed in its own manifest, renders the merged
unit and drop-ins with `systemd-analyze cat-config`, and reloads networkd.
`systemd-analyze verify` is not used because systemd rejects `.network` files
as service-unit inputs.

Links are not reconfigured and networkd is not restarted unless
`netplan_networkd_dropins_reconfigure` or
`netplan_networkd_dropins_restart` is explicitly enabled. Set `unit_name`
beneath a device only when Netplan generates a nonstandard filename.

## Author Information

Larry Smith Jr.

- [EverythingShouldBeVirtual](http://everythingshouldbevirtual.com)
- [@mrlesmithjr](https://www.twitter.com/mrlesmithjr)
- <mailto:mrlesmithjr@gmail.com>

<a href="https://www.buymeacoffee.com/mrlesmithjr" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
