require "thor"
require "zabbix-ruby-client"
require "zabbix-ruby-client/version"

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

    desc "start", "Collect data according to configuration"
    option :config,
      aliases: "-c",
      banner: "PATH",
      default: File.expand_path("config.yml", Dir.pwd),
      desc: "Path to the configuration file to use"
    def start
      begin
        Bundler.require
      rescue Bundler::GemfileNotFound
        say "No Gemfile found", :red
        abort
      end
      ZabbixRubyClient.run
    end
  end

end