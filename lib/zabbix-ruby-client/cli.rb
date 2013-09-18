require "thor"
require "zabbix-ruby-client"

module ZabbixRubyClient

  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("../../../templates", __FILE__)
    end

    default_task :help

    desc "init", "Initialize a new zabbix ruby client"
    def init(name = "zabbix-ruby-client")
      directory "client", name
    end

    desc "collect", "Collect data according to configuration"
    option :configfile,
      aliases: "-c",
      banner: "PATH",
      default: File.expand_path("config.yml", Dir.pwd),
      desc: "Path to the configuration file to use"
    def collect
      begin
        Bundler.require
      rescue Bundler::GemfileNotFound
        say "No Gemfile found", :red
        abort
      end
      ZabbixRubyClient.loadconfig options[:configfile]
      ZabbixRubyClient.collect
    end

    desc "upload", "Sends the collected data to the zabbix server"
    option :configfile,
      aliases: "-c",
      banner: "PATH",
      default: File.expand_path("config.yml", Dir.pwd),
      desc: "Path to the configuration file to use"
    def upload
      ZabbixRubyClient.loadconfig options[:configfile]
      ZabbixRubyClient.upload_last
    end

    desc "go", "Collects and sends data to the zabbix server"
    option :configfile,
      aliases: "-c",
      banner: "PATH",
      default: File.expand_path("config.yml", Dir.pwd),
      desc: "Path to the configuration file to use"
    def go
      ZabbixRubyClient.loadconfig options[:configfile]
      ZabbixRubyClient.collect
      ZabbixRubyClient.upload_last
    end

  end

end