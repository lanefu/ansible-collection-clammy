Role Name
=========

This role installs and configures [inadyn](https://github.com/troglobit/inadyn)

Requirements
------------

None.

Role Variables
--------------

`inadyn_perdiod`: Update interval

`inadyn_user_agent`: User agent to use

`inadyn_version`: Version to install. Only required when building from source.

`inadyn_install_source`: Whether to install inadyn from source

`inadyn_providers`: List of providers to add to the configuration. The following fields are available:

    - name: Name of the provider
    - username:
    - password:
    - checkip_server
    - checkip_ssl
    - checkip_path
    - checkip_command
    - ssl
    - user_agent
    - hostname
    - ttl
    - proxied
    - ddns_server
    - ddns_path
    - index: Indice to add when multiple provider of the same name are given


Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - mivek.inadyn
      vars:
        inadyn_install_source: true
        inadyn_version: 2.10.0
        inadyn_providers:
            - name: freedns
              username: freedns_user1
              password: strongpassword
              index: 1
              hostname: free.example.com
            - name: freedns
              username: freedns_user2
              password: strongpassword
              index: 2
              hostname: free2.example.com
            - name: dyn
              ssl: true
              username: charlie
              password: snoopy
              hostname: "{ peanuts,woodstock }"
              user_agent: "Mozilla/4.0"
    

License
-------

GNU General Public License v3.0

Author Information
------------------

[Github](https://github.com/mivek)
