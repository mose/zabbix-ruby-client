Zabbbix Ruby Client Changelog
-----------------------------

### v0.0.14 - wip

* better explanation about how to make custom plugins
* note on the readme about security and ssh tunnels
* added a redis plugin

### v0.0.13 - 2013-10-08

* added an nginx plugin

### v0.0.12 - 2013-10-07

* bugfix on memory calculation

### v0.0.11 - 2013-10-07

* fix on the memory statistiics collection
* added a who plugin, but not happy about it. I need to have a use of the API to reate graphs from the client, to list who is logged in. Sounds like an interesting way to get processes list up there too.
* added an option in disk plugin in case it's a loop device, then using args [ "", /tmp, "loop0" ] in config

### v0.0.10 - 2013-10-04

* added a mysql plugin (basic version, more will come on that one)

### v0.0.9 - 2013-10-02

* split configuration to have several upload frequencies
* added a -t option for specifying the list of plugins to run, default minutely.yml
* handled compatibility with previous configuration that includes list of plugins in config.yml
* added a sysinfo plugin for populating the hosts informations, including arbitrary information declared as plugin arguments
* started a mysql plugin but this one is not ready yet
* added an apt plugin to get the pending apt upgrades

### v0.0.8 - 2013-09-28

* adding load stats
* fix calcuation of percent of cpu used
* fix disk plugin to use proc rather than iostat
* various fixes in zabbix templates for disk io

### v0.0.7 - 2013-09-25

* fix network plugin
* added disk plugin and tepmlate
* various small templates fixes

### v0.0.6 - 2013-09-25

* added a discover method in plugin for pushed discoveries on network interfaces
** change your config file, args are now arrays for plugins
* change memory reports to Bytes rather than KBytes

### v0.0.5 - 2013-09-23

* fix generated gemfile
* fixes on readme
* adding a changelog

### v0.0.4 - 2013-09-21

* initial release
