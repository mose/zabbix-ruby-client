Zabbix Ruby Client
====================

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright Faria Systems 2013 - MIT license