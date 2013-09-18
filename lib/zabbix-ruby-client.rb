require "zabbix-ruby-client/version"
require "yaml"

module ZabbixRubyClient
  extend self

  def run(config_file)
    begin
      @config = YAML::load_file(config_file)
    rescue Exception => e
      puts "Configuration file cannot be read"
      puts e.message
      return
    end
    puts "running"
  end



end
