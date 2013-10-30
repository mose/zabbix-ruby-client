require "thor"
require "zabbix-ruby-client/runner"

module ZabbixRubyClient

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
    class_option :taskfile,
      aliases: "-t",
      banner: "PATH",
      default: File.expand_path("minutely.yml", Dir.pwd),
      desc: "Path to the list of plugins to execute"

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
      puts options
      config = YAML::load_file(options[:configfile])
      if File.exists? options[:taskfile]
        tasks = YAML::load_file(options[:taskfile])
      else
        tasks = config['plugins']
      end
      config['server'] = File.basename(options[:configfile],'.yml')
      config['taskfile'] = File.basename(options[:taskfile],'.yml')
      zrc = ZabbixRubyClient::Runner.new(config, tasks)
      zrc.collect
      zrc.show
    end

    desc "upload", "Collects and sends data to the zabbix server"
    def upload
      config = YAML::load_file(options[:configfile])
      if File.exists? options[:taskfile]
        tasks = YAML::load_file(options[:taskfile])
      else
        tasks = config['plugins']
      end
      config['server'] = File.basename(options[:configfile],'.yml')
      config['taskfile'] = File.basename(options[:taskfile],'.yml')
      zrc = ZabbixRubyClient::Runner.new(config, tasks)
      zrc.collect
      zrc.upload
    end

  end

end
