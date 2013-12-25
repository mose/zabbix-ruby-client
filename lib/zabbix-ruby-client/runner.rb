require "zabbix-ruby-client/store"
require "zabbix-ruby-client/data"
require "zabbix-ruby-client/plugins"
require "zabbix-ruby-client/logger"

module ZabbixRubyClient

  class Runner

    def initialize(config, tasks)
      @config = config
      @tasks = tasks

      @store = ZabbixRubyClient::Store.new(
        @config['datadir'],
        @config['zabbix']['host'],
        @config['taskfile'],
        @config['keepdata']
      )

      @data = ZabbixRubyClient::Data.new(@config['host'])
      @logsdir = makedir(@config['logsdir'], 'logs')
      ZabbixRubyClient::Plugins.scan_dirs([ PLUGINDIR ] + @config['plugindirs'])
      ZabbixRubyClient::Log.set_logger(File.join(@logsdir, 'zrc.log'), @config['loglevel'])
      ZabbixRubyClient::Log.debug @config.inspect
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
      command = "#{@config['zabbix']['sender']} -z #{@config['zabbix']['host']} -p #{@config['zabbix']['port']} -T -i #{file}"
      ZabbixRubyClient::Log.debug command
      begin
        res = `#{command}`
        case $?.to_i
        when 0
          ZabbixRubyClient::Log.debug "zabbix-sender: Data Sent"
        when 1
          @store.keepdata(file)
          ZabbixRubyClient::Log.error "zabbix-sender: Sending failed"
          ZabbixRubyClient::Log.error res
        when 2
          ZabbixRubyClient::Log.warn "zabbix-sender: Some values failed"
          ZabbixRubyClient::Log.warn res
        else
          ZabbixRubyClient::Log.error "zabbix-sender: Something failed. code #{$?.to_i} was returned"
          ZabbixRubyClient::Log.error res
        end
      rescue Exception => e
        @store.keepdata(file)
        ZabbixRubyClient::Log.error "zabbix-sender: broken."
        ZabbixRubyClient::Log.error e.message
      end
    end

    private

    def makedir(configdir, defaultdir)
      dir = configdir || defaultdir
      FileUtils.mkdir dir unless Dir.exists? dir
      dir
    end

  end
end
