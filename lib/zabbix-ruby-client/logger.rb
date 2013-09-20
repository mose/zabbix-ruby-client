require "logger"

module ZabbixRubyClient
  module Logger
    extend self

    def get_logger(dir, level)
      logger = ::Logger.new(File.join(dir,"zrc.log"))
      logger.level = get_level_constant(level)
      logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime.utc}] #{severity}: #{msg}\n"
      end
      logger
    end

    def get_level_constant(level)
      if level
        begin
          ::Logger.const_get(level.to_s.upcase)
        rescue NameError
          return ::Logger::INFO
        end
      else
        ::Logger::INFO
      end
    end

  end
end