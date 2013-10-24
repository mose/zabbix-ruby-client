require "zabbix-ruby-client/version"
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugins"
require "zabbix-ruby-client/registry"
require "zabbix-ruby-client/store"
require "zabbix-ruby-client/data"
require "yaml"

class ZabbixRubyClient

  PLUGINDIR = File.expand_path("../zabbix-ruby-client/plugins", __FILE__)

  def initialize(config_file, task_file)
    begin
      @config ||= YAML::load_file(config_file)
      if File.exists? task_file
        @tasks ||= YAML::load_file(task_file)
      else
        @tasks = @config["plugins"]
      end
    rescue Exception => e
      puts "Configuration file cannot be read"
      puts e.message
      return
    end
    @config["server"] = File.basename(config_file,'.yml')

    @store = Store.new(
      @config['datadir'],
      @config['zabbix']['host'],
      File.basename(task_file,'.yml'),
      @config['keepdata']
    )

    @data = ZabbixRubyClient::Data.new(@config['host'])
    @logsdir = makedir(@config['logsdir'],'logs')
    Plugins.scan_dirs([ PLUGINDIR ] + @config["plugindirs"])
    logger.debug @config.inspect
  end

  def load_plugins(dirs)
    ZabbixRubyClient::Registry.new(dirs)
  end

  def collect
    @tasks.each do |plugin|
      @data.run_plugin(plugin['name'], plugin['args'])
    end
  end

  def show
    @data.merge.each do |line|
      puts line
    end
  end

  def upload
    file = @store.record(@data.merge)
    begin
      res = `#{@config['zabbix']['sender']} -z #{@config['zabbix']['host']} -p #{@config['zabbix']['port']} -T -i #{file}`
      if $?.to_i != 0
        @store.keepdata(file)
      end
    rescue Exception => e
      @store.keepdata(file)
      logger.error "Sending failed."
      logger.error e.message
    end
  end

  def logger
    @logger ||= Logger.get_logger(@logsdir, @config["loglevel"])
  end

  private

  def makedir(configdir, defaultdir)
    dir = configdir || defaultdir
    FileUtils.mkdir dir unless Dir.exists? dir
    dir
  end

end
