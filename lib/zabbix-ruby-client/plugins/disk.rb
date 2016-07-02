# some doc on
# http://www.xaprb.com/blog/2010/01/09/how-linux-iostat-computes-its-results/
# http://www.mjmwired.net/kernel/Documentation/iostats.txt
require "zabbix-ruby-client/logger"
require "zabbix-ruby-client/plugin_base"

module ZabbixRubyClient
  module Plugins
    module Disk
      extend self
      extend ZabbixRubyClient::PluginBase

      def collect(*args)
        host = args[0]
        dev = args[1]
        mapped = args[3] || dev

        info = get_info(dev, mapped)
        if info
          back = []
          back << "#{host} disk.space[#{mapped},size] #{time} #{to_m(info[1])}"
          back << "#{host} disk.space[#{mapped},used] #{time} #{to_m(info[2])}"
          back << "#{host} disk.space[#{mapped},available] #{time} #{to_m(info[3])}"
          back << "#{host} disk.space[#{mapped},percent_used] #{time} #{info[4].gsub(/%/,'')}"
          back << "#{host} disk.io[#{mapped},read_ok] #{time} #{info[9]}"
          back << "#{host} disk.io[#{mapped},read_merged] #{time} #{info[10]}"
          back << "#{host} disk.io[#{mapped},read_sector] #{time} #{info[11]}"
          back << "#{host} disk.io[#{mapped},read_time] #{time} #{info[12]}"
          back << "#{host} disk.io[#{mapped},write_ok] #{time} #{info[13]}"
          back << "#{host} disk.io[#{mapped},write_merged] #{time} #{info[14]}"
          back << "#{host} disk.io[#{mapped},write_sector] #{time} #{info[15]}"
          back << "#{host} disk.io[#{mapped},write_time] #{time} #{info[16]}"
          back << "#{host} disk.io[#{mapped},io_time] #{time} #{info[17]}"
          back << "#{host} disk.io[#{mapped},io_weighted] #{time} #{info[18]}"
        end
        return back
      end

      def discover(*args)
        device = args[0]
        mount = args[1]
        mapped = args[2] || device
        [ "disk.dev.discovery",
          "{\"{#DISK_DEVICE}\": \"#{mapped}\", \"{#DISK_MOUNT}\": \"#{mount}\"}"
        ]
      end

    private

      def to_m(s)
        s.to_i * 1000
      end

      def get_info(disk, device)
        info = diskinfo(device)
        if info
          back = info.split(/\s+/)
          case os
          when :linux
            io = getline("/proc/diskstats", " #{disk} ")
            if io
              back += io.split(/\s+/)
            end
          when :unix
            output = `iostat -x | grep "#{disk}"`
            data = output.split(/\s+/)
            back << 0 # --
            back << 0 # --
            back << 0 # --
            back << data[3] # read_ok
            back << 0 # read_merged
            back << 0 # read_sector
            back << 0 # read_time
            back << data[4] # write_ok
            back << 0 # write_merged
            back << 0 # write_sector
            back << 0 # write_time
            back << 0 # io_time
            back << 0 # io_merged
          else
            return false
          end
          back
        else
          false
        end
      end

      def diskinfo(disk)
        output = `df | grep "#{disk}"`
        if $?.to_i == 0
          Log.debug self
          Log.debug output
          output
        else
          Log.warn "Oh there is no such device."
          false
        end
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('disk', ZabbixRubyClient::Plugins::Disk)
