require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Mysqlcommand
      extend self

      def collect(*args)
        host = args.shift
        app = args.shift
        mysqldb = args.shift
        mysqlargs = args.shift
        mysqlcommand = "mysql #{mysqlargs} -s --skip-column-names -e \"%s\" #{mysqldb}"
        back = []
        Hash[*args].each do |name, command|
          time = Time.now.to_i
          comm = sprintf(mysqlcommand, command.gsub(/"/,'\"'))
          res = `#{comm}`
          if $?.to_i == 0
            if name[0] == "_"
              res.each_line do |line|
                label, value = line,split("\t")
                back << "#{host} app.#{app}[#{name[1..-1]},#{label}] #{time} #{value}"
              end
            elsif name[/,/]
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

