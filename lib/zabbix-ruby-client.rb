require "zabbix-ruby-client/version"
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugins"
require "yaml"

class ZabbixRubyClient

  def initialize(config_file)
    begin
      @config ||= YAML::load_file(config_file)
    rescue Exception => e
      puts "Configuration file cannot be read"
      puts e.message
      return
    end
    @logsdir = makedir(@config['logsdir'],'logs')
    @datadir = makedir(@config['datadir'],'data')
    @plugindirs = [ File.expand_path("../zabbix-ruby-client/plugins", __FILE__) ]
    if @config["plugindirs"]
      @plugindirs = @plugindirs + @config["plugindirs"]
    end
    Plugins.load_dirs @plugindirs
  end

  def data
    @data ||= []
  end

  def datafile
    @datafile ||= if @config['keepdata'] == "yes"
      File.join(@datadir,"data_"+Time.now.strftime("%Y%m%d_%h%m%s"))
    else
      File.join(@datadir,"data")
    end
  end

  def run_plugin(plugin, args = nil)
    Plugins.load(plugin) || logger.error( "Plugin #{plugin} not found.")
    if Plugins.loaded[plugin]
      begin
        @data = data + Plugins.loaded[plugin].send(:collect, @config['host'], args)
      rescue Exception => e
        logger.fatal "Oops"
        logger.fatal e.message
      end
    end
  end

  def collect
    @config['plugins'].each do |plugin|
      run_plugin(plugin['name'], plugin['args'])
    end
    logger.info data.flatten.inspect
  end

  def store
    File.open(datafile, "w") do |f|
      data.each do |d|
        f.puts d
      end
    end
  end

  def upload
    logger.info "zabbix_sender -z #{@config['zabbix']['host']} "
  end

  private

  def makedir(configdir, defaultdir)
    dir = configdir || defaultdir
    FileUtils.mkdir dir unless Dir.exists? dir
    dir
  end

  def logger
    @logger ||= Logger.get_logger(@logsdir, @config["loglevel"])
  end

end
