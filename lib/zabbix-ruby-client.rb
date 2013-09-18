require "zabbix-ruby-client/version"
require "yaml"

module ZabbixRubyClient
  extend self

  def run
    begin
      @config = YAML::load_file(CONFIG_FILE)
    rescue Exception => e
      puts "Configuration file cannot be read"
      puts e.msg
      return
    end
    puts "running"
  end



end
