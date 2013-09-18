require "zabbix-ruby-client/version"
require "yaml"

module ZabbixRubyClient
  extend self

  def loadconfig(config_file)
    begin
      @config ||= YAML::load_file(config_file)
    rescue Exception => e
      puts "Configuration file cannot be read"
      puts e.message
      return
    end
    puts "Config loaded"
  end

  def datadir
    dir = File.expand_path("data", Dir.pwd)
    FileUtils.mkdir_p(dir) unless File.dir? dir
    dir
  end

  def available_plugins
    @available_plugins ||= Dir.glob(File.join("lib","zabbix-ruby-client","plugins","*.rb"))
  end

  def plugins
    @plugins ||= {}
  end

  def register_plugin(plugin, klass)
    plugins[plugin] = klass
  end

  def data
    @data ||= []
  end

  def load_plugin(plugin)
    unless @plugins[plugin]
      if @available_plugins[plugin]
        load @available_plugins[plugin]
      else
        puts "Plugin #{plugin} not found."
        abort
      end
    end
  end

  def run_plugin(plugin, args = nil)
    load_plugin plugin
    begin
      add_data(@plugins[plugin].send(:collect, args))
    rescue Exception => e
      puts "Oops"
      puts e.message
    end
  end

  def collect
    back = []
    @config['plugins'].each do |plugin|
      back.merge load_plugin(plugin['name'], plugin['args'])
    end
    puts @config['zabbix']['host']
  end

  def upload
    puts "zabbix_sender -z #{@config['zabbix']['host']} "
  end

end
