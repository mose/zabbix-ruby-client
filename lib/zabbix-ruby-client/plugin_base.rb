require 'rbconfig'
require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module PluginBase
    extend self

    def httprequest(url)
    end

    def perform(command)
    end

    def time
      @_now ||= Time.now.to_i
    end

    def os
      @_os ||= (
        host_os = RbConfig::CONFIG['host_os']
        case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          :windows
        when /darwin|mac os/
          :macosx
        when /linux/
          :linux
        when /solaris|bsd/
          :unix
        else
          raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
        end
      )
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

    def getlines(file, pattern=false)
      lines = []
      if File.readable? file
        File.open(file,'r') do |f|
          f.each do |l|
            line = l.strip
            if pattern
              if Regexp.new(pattern).match line
                Log.debug "File #{file}: #{line}"
                lines << line
              end
            else
               lines << line
            end
          end
        end
        Log.warn "File #{file}: pattern \"#{pattern}\" not found." unless lines.count > 0
        lines
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
