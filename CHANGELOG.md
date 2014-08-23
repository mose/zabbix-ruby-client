Zabbbix Ruby Client Changelog
-----------------------------

### v0.1.0 - 2014-08-22
- remove bundler dependency
- minor code refactoring

### v0.0.23 - 2014-08-09
- oops, buggy mysqlcommand fixed

### v0.0.22 - 2014-08-09
- added RabbitMQ plugin
- added mysqlcommand plugin for graphing arbitrary mysql commands

### v0.0.21 - 2014-08-01
- fix zabbix_sender return code 256
- update all templates with shorter history
- added a simple openvpn plugin + template
- small fix on network template
- improved postgres template
- add cisco template

### v0.0.20 - 2013-12-25
- fix network plugin
- fix new return code handling from zabbix_sender 2.2.x
- more debugging info when loglevel: debug

### v0.0.19 - 2013-12-24
- fix on logger when zabbix-sender command fails
- fix on the disk plugin handling of third argument

### v0.0.18 - 2013-12-13
- total fix on CPU usage plugin
- added a postgres plugin (per database)
- refactoring of plugins
- fixed typo on count of start processes in apache plugin
- made plugin collection optional, so you can have a plugin for only discovery
- more tests and coverage

### v0.0.17 - 2013-10-31
- bugfix on requires

### v0.0.16 - 2013-10-31
- _if you have custom plugins_ the class ZabbixRubyClient is now a module just for namespacing, update your code!
- fix the logger
- refactoring and more tests
- adding travis and coverall to stimulate testing, also added gemnasium

### v0.0.15 - 2013-10-23
- prototype of a way to keep data when sending fails and sending it again at next iteration
- refactoring in several classes for better testability and nicer code
- add port in the zabbix-sender command that was forgotten there
- fix disk template alarm subject
- fix datafile naming for when you get different task files ran at same time
- improve cpu and disk triggers with dependencies (but waiting for ZBXNEXT-1229)

### v0.0.14 - 2013-10-14
- better explanation about how to make custom plugins
- note on the readme about security and ssh tunnels
- added a redis plugin and template

### v0.0.13 - 2013-10-08
- added an nginx plugin

### v0.0.12 - 2013-10-07
- bugfix on memory calculation

### v0.0.11 - 2013-10-07
- fix on the memory statistiics collection
- added a who plugin, but not happy about it. I need to have a use of the API to reate graphs from the client, to list who is logged in. Sounds like an interesting way to get processes list up there too.
- added an option in disk plugin in case it's a loop device, then using args [ "", /tmp, "loop0" ] in config

### v0.0.10 - 2013-10-04
- added a mysql plugin (basic version, more will come on that one)

### v0.0.9 - 2013-10-02
- split configuration to have several upload frequencies
- added a -t option for specifying the list of plugins to run, default minutely.yml
- handled compatibility with previous configuration that includes list of plugins in config.yml
- added a sysinfo plugin for populating the hosts informations, including arbitrary information declared as plugin arguments
- started a mysql plugin but this one is not ready yet
- added an apt plugin to get the pending apt upgrades

### v0.0.8 - 2013-09-28
- adding load stats
- fix calcuation of percent of cpu used
- fix disk plugin to use proc rather than iostat
- various fixes in zabbix templates for disk io

### v0.0.7 - 2013-09-25
- fix network plugin
- added disk plugin and tepmlate
- various small templates fixes

### v0.0.6 - 2013-09-25
- added a discover method in plugin for pushed discoveries on network interfaces
  - change your config file, args are now arrays for plugins
- change memory reports to Bytes rather than KBytes

### v0.0.5 - 2013-09-23
- fix generated gemfile
- fixes on readme
- adding a changelog

### v0.0.4 - 2013-09-21
- initial release
