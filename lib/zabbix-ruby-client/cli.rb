require "thor"
require "zabbix-ruby-client/version"

module ZabbixRubyClient

  class Cli < Thor
    include Thor::Actions
  end

  default_task :help

  desc "init", "Initialize a new zabbix ruby client"
  def init(name = "zabbix-ruby-client")
    directory "client", name
  end

  desc "run", "Collect data according to configuration"
  def run
  end

  
end