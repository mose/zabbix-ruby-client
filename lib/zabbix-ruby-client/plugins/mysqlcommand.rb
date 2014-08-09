require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Mysqlcommand
      extend self

      def collect(*args)
        host = args.delete
        app = args.delete
        mysqldb = args.delete
        mysqlargs = args.delete
        mysqlcommand = "mysql #{mysqlargs} -s --skip-column-names \"%s\" #{mysqldb}"
        back = []
        Hash.new(args).each do |name, command|
          time = Time.now.to_i
          res = `#{sprintf mysqlcommand, command.gsub(/"/,'\"')}`
          if $?.to_i == 0
            if name == "_"
              res.each_line do |line|
                label, value = line,split("\t")
                back << "#{host} app.#{app}[#{label}] #{time} #{value}"
              end
            if name[/,/]
              res = res.split("\t")
              name.split(',').each_with_index do |n, i|
                back << "#{host} app.#{app}[#{n}] #{time} #{res[i]}"
              end
            else
              back << "#{host} app.#{app}[#{name}] #{time} #{res}"
            end
          else
            Log.warn "The connection failed."
            return []
          end

        end
        return back
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('mysqlcommand', ZabbixRubyClient::Plugins::Mysqlcommand)

