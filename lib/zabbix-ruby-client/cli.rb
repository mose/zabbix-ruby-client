require "thor"
require "zabbix-ruby-client"

class ZabbixRubyClient

  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("../../../templates", __FILE__)
    end

    default_task :help
    class_option :configfile,
      aliases: "-c",
      banner: "PATH",
      default: File.expand_path("config.yml", Dir.pwd),
      desc: "Path to the configuration file to use"

    desc "init", "Initialize a new zabbix ruby client"
    def init(name = "zabbix-ruby-client")
      directory "client", name
    end

    desc "show", "Displays in console what are the collected data ready to be sent"
    def show
      begin
        Bundler.require
      rescue Bundler::GemfileNotFound
        say "No Gemfile found", :red
        abort
      end
      zrc = ZabbixRubyClient.new(options[:configfile])
      zrc.collect
      zrc.show
    end

    desc "upload", "Collects and sends data to the zabbix server"
    def upload
      zrc = ZabbixRubyClient.new(options[:configfile])
      zrc.collect
      zrc.upload
    end

  end

end