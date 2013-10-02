class ZabbixRubyClient
  module Plugins
    module Sysinfo
      extend self

      def collect(*args)
        host = args.delete(0)
        uname = `uname -a`
        if $?.to_i == 0
          arch, hostname, kernel, kernel_version, machine, proc,
          _, _, _, _, _, _, _, platform, os = uname.split(/ /)
        else
          logger.warn "Are you running on ubuntu ?"
          return []
        end
        time = Time.now.to_i
        back = []
        back << "#{host} sysinfo[name] #{time} #{host}"
        back << "#{host} sysinfo[arch] #{time} #{arch}"
        back << "#{host} sysinfo[hostname] #{time} #{hostname}"
        back << "#{host} sysinfo[kernel] #{time} #{kernel}"
        back << "#{host} sysinfo[kernel_version] #{time} #{kernel_version}"
        back << "#{host} sysinfo[machine] #{time} #{machine}"
        back << "#{host} sysinfo[platform] #{time} #{platform}"
        back << "#{host} sysinfo[os] #{time} #{os}"
        Hash.new(args).each do |k,v|
          back << "#{host} sysinfo[#{k}] #{time} #{v}"
        end
        return back
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('sysinfo', ZabbixRubyClient::Plugins::Sysinfo)

