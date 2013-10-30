require "zabbix-ruby-client/version"
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugins"
require "zabbix-ruby-client/store"
require "zabbix-ruby-client/data"
require "yaml"

class ZabbixRubyClient

  PLUGINDIR = File.expand_path("../zabbix-ruby-client/plugins", __FILE__)

  def initialize(config, tasks)
    @config = config
    @tasks = tasks

    @store = Store.new(
      @config['datadir'],
      @config['zabbix']['host'],
      @config['taskfile'],
      @config['keepdata']
    )

    @data = ZabbixRubyClient::Data.new(@config['host'])
    @logsdir = makedir(@config['logsdir'], 'logs')
    Plugins.scan_dirs([ PLUGINDIR ] + @config['plugindirs'])
    Log.set_logger(File.join(@logsdir, 'zrc.log'), 'info')
    Log.debug @config.inspect
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

  private

  def makedir(configdir, defaultdir)
    dir = configdir || defaultdir
    FileUtils.mkdir dir unless Dir.exists? dir
    dir
  end

end
