Zabbix Ruby Client
====================

[![Code Climate](https://codeclimate.com/github/eduvo/zabbix-ruby-client.png)](https://codeclimate.com/github/eduvo/zabbix-ruby-client)

This tool is designed to make easy to install zabbix reporter on monitored servers using zabbix-sender rather than zabbix-agent. It targets on monitoring mainly linux servers and is built on a plugin system so that you can decide what is going to be reported.

The development is still in progress but it produces results and works in my case. Use at your own risk and read the code first. It is developed under ruby 2 but should work on 1.9.3 as well.

Check the [Changelog](CHANGELOG.md) for recent changes, code is still under huge development and is likely to move a lot until version 0.1.

## Installation

Install it yourself as:

    gem install zabbix-ruby-client

## Usage

    zrc init [name]
    # will create a directory [name] (default: zabbix-ruby-client) for
    # storing configuration and temporary files

    cd [name]
    bundle
    # makes the zabbix-ruby-client [name] ready to run
    # then edit config.yml according to your needs

    bundle exec zrc
    # to list available commands

    bundle exec zrc show 
    # to test the data collection

And when ready just install a cron task according to your environment

    echo '* * * * * /bin/bash -lc "cd /path/to/zrc && bundle exec zrc upload"' | crontab
    # or
    echo '* * * * * /bin/zsh -c ". $HOME/.rvm/scripts/rvm && cd /path/to/zrc && bundle exec zrc upload"' | crontab
    # or
    echo '* * * * * /bin/zsh -c "export RBENV_ROOT=/usr/local/var/rbenv && eval \"$(rbenv init - zsh)\" && cd /path/to/zrc && bundle exec zrc upload"' | crontab

## plugins

There are a set of standart plugins included in the package, aimed at linux systems.

* load (uses /proc/loadavg)
* cpu (uses /proc/stat) [cpu_tpl](master/zabbix-templates/cpu_tpl.xml)
* memory (requires iostat, apt-get install sysstat) [memory_tpl](master/zabbix-templates/memory_tpl.xml)
* disk (uses /proc/diskstats) [disk_tpl](master/zabbix-templates/disk_tpl.xml)
* network (uses /proc/net/dev) [network_tpl](master/zabbix-templates/network_tpl.xml)
* apache (depends on mod_status with status_extended on) [apache_tpl](master/zabbix-templates/apache_tpl.xml)

You can add extra plugin directories in the configuration file.

## Todo

* read /proc rather than rely on installed tools
* write tests
* add more plugins
  * memcache
  * redis
  * mysql master/slave
  * monit
  * passenger
  * nginx
  * logged users
  * denyhosts
  * postfix
  * sendgrid
  * airbrake
  * disk occupation
* try to work out a way to create host/graphs/alerts from the client using Zabbix API
* verify compatibility with ruby 1.9


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

* [@mose](https://github.com/mose) - author

## License

Copyright 2013 [Faria Systems](http://faria.co) - MIT license - created by mose at mose.com
