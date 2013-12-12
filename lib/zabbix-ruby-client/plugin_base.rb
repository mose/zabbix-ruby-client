require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module PluginBase
    extend self

    def httprequest(url)
    end

    def perform(command)
    end

    def getline(file, pattern=false)
      if File.readable? file
        File.open(file,'r') do |f|
          f.each do |l|
            line = l.strip
            if pattern
              if Regexp.new(pattern).match line
                Log.debug "File #{file}: #{line}"
                return line
              end
            else
              return line
            end
          end
        end
        Log.warn "File #{file}: pattern \"#{pattern}\" not found."
        false
      else
        if File.file? file
          Log.error "File not readable: #{file}"
        else
          Log.error "File not found: #{file}"
        end
        false
      end
    end

  end
end
