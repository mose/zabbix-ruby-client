Zabbix Ruby Client
====================

[![Code Climate](https://codeclimate.com/github/eduvo/zabbix-ruby-client.png)](https://codeclimate.com/github/eduvo/zabbix-ruby-client)

This tool is designed to make easy to install zabbix reporter on monitored servers using zabbix-sender rather than zabbix-agent. It targets on monitoring mainly linux servers and is built on a plugin system so that you can decide what is going to be reported.

The development is still in progress and this code is not yet usable.

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

    zrc 
    # to list available commands

And when ready just install a cron task according to your environment

    echo '* * * * * /bin/bash -lc "cd /path/to/zrc && bundle exec zrc go"' | crontab
    # or
    echo '* * * * * /bin/zsh -c ". $HOME/.rvm/scripts/rvm && cd /path/to/zrc && bundle exec zrc go"' | crontab
    # or
    echo '* * * * * /bin/zsh -c "export RBENV_ROOT=/usr/local/var/rbenv && eval \"$(rbenv init - zsh)\" && cd /path/to/zrc && bundle exec zrc go"' | crontab

## plugins

There are a set of standart plugins included in the package, aimed at linux systems.

* cpu (requires mpstat, apt-get install sysstat)
* memory (requires iostat, apt-get install sysstat)
* disk (requires iostat, apt-get install sysstat)
* network (requires netstat, apt-get install netstat)
* apache (depends on mod_status with status_extended on)

You can add extra plugin directories in the configuration file.

## Todo

* write tests
* add more plugins
** memcache
** redis
** mysql master/slave
** monit
** passenger
** nginx
** logged users
** denyhosts
** postfix
** sendgrid
** airbrake
** disk occupation
* try to work out a way to create host/graphs/alerts from the client using Zabbix API


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright Faria Systems 2013 - MIT license
