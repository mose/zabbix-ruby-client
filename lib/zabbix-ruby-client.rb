require "zabbix-ruby-client/version"
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugins"
require "yaml"

class ZabbixRubyClient

  def initialize(config_file,task_file)
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
    @config["task"] = File.basename(task_file,'.yml')
    @logsdir = makedir(@config['logsdir'],'logs')
    @datadir = makedir(@config['datadir'],'data')
    @plugindirs = [ File.expand_path("../zabbix-ruby-client/plugins", __FILE__) ]
    if @config["plugindirs"]
      @plugindirs = @plugindirs + @config["plugindirs"]
    end
    @discover = {}
    @data = []
    Plugins.load_dirs @plugindirs
    logger.debug @config.inspect
  end

  def datafile
    now = Time.now
    @datafile ||= if @config['keepdata']
      unless Dir.exists? File.join(@datadir,Time.now.strftime("%Y-%m-%d"))
        FileUtils.mkdir File.join(@datadir,Time.now.strftime("%Y-%m-%d"))
      end
      File.join(@datadir,Time.now.strftime("%Y-%m-%d"),"#{@config["task"]}-data_"+Time.now.strftime("%H%M%S"))
    else
      File.join(@datadir,"#{@config["task"]}-data")
    end
  end

  def run_plugin(plugin, args = nil)
    Plugins.load(plugin) || logger.error( "Plugin #{plugin} not found.")
    if Plugins.loaded[plugin]
      begin
        @data = @data + Plugins.loaded[plugin].send(:collect, @config['host'], *args)
        if Plugins.loaded[plugin].respond_to?(:discover)
          key, value = Plugins.loaded[plugin].send(:discover, *args)
          @discover[key] ||= []
          @discover[key] << [ value ]
        end
      rescue Exception => e
        logger.fatal "Oops"
        logger.fatal e.message
      end
    endT
  end

  def collect
    @tasks.each do |plugin|
      run_plugin(plugin['name'], plugin['args'])
    end
  end

  def show
    merge_discover
    @data.each do |line|
      puts line
    end
  end

  def store
    File.open(datafile, "w") do |f|
      @data.each do |d|
        f.puts d
      end
    end
  end

  def merge_discover
    time = Time.now.to_i
    @data = @discover.reduce([]) do |a,(k,v)|
      a << "#{@config['host']} #{k} #{time} { \"data\": [ #{v.join(', ')} ] }"
      a
    end + @data
  end

  def upload
    merge_discover
    store
    begin
      res = `#{@config['zabbix']['sender']} -z #{@config['zabbix']['host']} -T -i #{datafile}`
      if $?.to_i != 0
        keepdata
      end
    rescue Exception => e
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

  def keepdata
  end

  def logger
    @logger ||= Logger.get_logger(@logsdir, @config["loglevel"])
  end

end
