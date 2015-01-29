require "zabbix-ruby-client/logger"

module ZabbixRubyClient
  module Plugins
    module Sysinfo
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args.delete_at(0)
        uname = `uname -a`
        if $?.to_i == 0
          arch, hostname, kernel, kernel_version, machine, os_debian,
          _, platform_debian, _, _, _, _, _, platform, os = uname.split(/ /)
        else
          Log.warn "Are you running on ubuntu ?"
          return []
        end
        back = []
        back << "#{host} sysinfo[name] #{time} #{host}"
        back << "#{host} sysinfo[arch] #{time} #{arch}"
        back << "#{host} sysinfo[hostname] #{time} #{hostname}"
        back << "#{host} sysinfo[kernel] #{time} #{kernel}"
        back << "#{host} sysinfo[kernel_version] #{time} #{kernel_version}"
        back << "#{host} sysinfo[machine] #{time} #{machine}"
        back << "#{host} sysinfo[platform] #{time} #{platform || platform_debian}"
        back << "#{host} sysinfo[os] #{time} #{os || os_debian}"
        Hash[*args].each do |k,v|
          back << "#{host} sysinfo[#{k}] #{time} #{v}"
        end
        return back
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('sysinfo', ZabbixRubyClient::Plugins::Sysinfo)

