require "zabbix-ruby-client/version"
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugins"
require "yaml"

class ZabbixRubyClient

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

    @store = Store.new(
      File.join(@config['datadir'],'data'),
      @config['zabbix']['host'],
      File.basename(task_file,'.yml'),
      @config['keepdata']
    )

    @data = Data.new

    @config["server"] = File.basename(config_file,'.yml')
    @logsdir = makedir(@config['logsdir'],'logs')
    @plugindirs = [ File.expand_path("../zabbix-ruby-client/plugins", __FILE__) ]
    if @config["plugindirs"]
      @plugindirs = @plugindirs + @config["plugindirs"]
    end
    Plugins.load_dirs @plugindirs
    logger.debug @config.inspect
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
