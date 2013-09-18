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
    @available_plugins ||= Dir.glob(File.expand_path("../zabbix-ruby-client/plugins/*.rb", __FILE__)).reduce(Hash.new) { |a,x|
      { File.basename(x,".rb") => x }
    }
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
    unless plugins[plugin]
      if available_plugins[plugin]
        load available_plugins[plugin]
      else
        puts "Plugin #{plugin} not found."
      end
    end
  end

  def run_plugin(plugin, args = nil)
    load_plugin plugin
    if plugins[plugin]
      begin
        data << plugins[plugin].send(:collect, args)
      rescue Exception => e
        puts "Oops"
        puts e.message
      end
    end
  end

  def collect
    @config['plugins'].each do |plugin|
      run_plugin(plugin['name'], plugin['args'])
    end
    puts data.flatten.inspect
  end

  def upload
    puts "zabbix_sender -z #{@config['zabbix']['host']} "
  end

end
