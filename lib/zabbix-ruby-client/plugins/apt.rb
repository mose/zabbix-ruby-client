class ZabbixRubyClient
  module Plugins
    module Apt
      extend self

      def collect(*args)
        host = args[0]
        aptcheck = `/usr/lib/update-notifier/apt-check 2>&1`
        if $?.to_i == 0
          security, pending = aptcheck.split(/;/).map(&:to_i)
        else
          logger.warn "Are you running on ubuntu ?"
          return []
        end
        time = Time.now.to_i
        back = []
        back << "#{host} apt[security] #{time} #{security}"
        back << "#{host} apt[pending] #{time} #{pending}"
        back << "#{host} apt[status] #{time} TODO apt #{security}/#{pending}"
        return back
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('apt', ZabbixRubyClient::Plugins::Apt)

