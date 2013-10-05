# some doc on
# http://www.xaprb.com/blog/2010/01/09/how-linux-iostat-computes-its-results/
# http://www.mjmwired.net/kernel/Documentation/iostats.txt

class ZabbixRubyClient
  module Plugins
    module Disk
      extend self

      def collect(*args)
        host = args[0]
        dev = args[1]
        mapped = args[3] || dev
        diskspace = `df | grep "#{mapped}"`
        if $?.to_i == 0
          _, size, used, available, percent_used, mount = diskspace.split(/\s+/)
        else
          logger.error "df is not working... ouchie."
          return []
        end
        time = Time.now.to_i
        back = []
        back << "#{host} disk.space[#{mapped},size] #{time} #{size.to_i * 1000}"
        back << "#{host} disk.space[#{mapped},used] #{time} #{used.to_i * 1000}"
        back << "#{host} disk.space[#{mapped},available] #{time} #{available.to_i * 1000}"
        back << "#{host} disk.space[#{mapped},percent_used] #{time} #{percent_used.gsub(/%/,'')}"

        if dev != ""
          diskinfo = `cat /proc/diskstats | grep " #{dev} "`
          if $?.to_i == 0
            _, _, _, _, read_ok, read_merged, read_sector, read_time, write_ok, write_merged, write_sector, write_time, io_current, io_time, io_weighted = diskinfo.split(/\s+/)
          else
            logger.warn "Oh there is no such device."
            return []
          end
          back << "#{host} disk.io[#{mapped},read_ok] #{time} #{read_ok}"
          back << "#{host} disk.io[#{mapped},read_merged] #{time} #{read_merged}"
          back << "#{host} disk.io[#{mapped},read_sector] #{time} #{read_sector}"
          back << "#{host} disk.io[#{mapped},read_time] #{time} #{read_time}"
          back << "#{host} disk.io[#{mapped},write_ok] #{time} #{write_ok}"
          back << "#{host} disk.io[#{mapped},write_merged] #{time} #{write_merged}"
          back << "#{host} disk.io[#{mapped},write_sector] #{time} #{write_sector}"
          back << "#{host} disk.io[#{mapped},write_time] #{time} #{write_time}"
          back << "#{host} disk.io[#{mapped},io_time] #{time} #{io_time}"
          back << "#{host} disk.io[#{mapped},io_weighted] #{time} #{io_weighted}"
        end
        return back
      end

      def discover(*args)
        device = args[0]
        mount = args[1]
        [ "disk.dev.discovery", "{\"{#DISK_DEVICE}\": \"#{device}\", \"{#DISK_MOUNT}\": \"#{mount}\"}" ]
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('disk', ZabbixRubyClient::Plugins::Disk)
