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
        diskinfo = `cat /proc/diskstats | grep " #{dev} "`
        if $?.to_i == 0
          _, _, _, _, read_ok, read_merged, read_sector, read_time, write_ok, write_merged, write_sector, write_time, io_current, io_time, io_weighted = diskinfo.split(/\s+/)
        else
          logger.warn "Please install sysstat."
          return []
        end
        diskspace = `df | grep "#{dev}"`
        if $?.to_i == 0
          _, size, used, available, percent_used, mount = diskspace.split(/\s+/)
        else
          logger.error "df is not working... ouchie."
          return []
        end

        time = Time.now.to_i
        back = []
        back << "#{host} disk.io[#{dev},read_ok] #{time} #{read_ok}"
        back << "#{host} disk.io[#{dev},read_merged] #{time} #{read_merged}"
        back << "#{host} disk.io[#{dev},read_sector] #{time} #{read_sector}"
        back << "#{host} disk.io[#{dev},read_time] #{time} #{read_time}"
        back << "#{host} disk.io[#{dev},write_ok] #{time} #{write_ok}"
        back << "#{host} disk.io[#{dev},write_merged] #{time} #{write_merged}"
        back << "#{host} disk.io[#{dev},write_sector] #{time} #{write_sector}"
        back << "#{host} disk.io[#{dev},write_time] #{time} #{write_time}"
        back << "#{host} disk.io[#{dev},io_current] #{time} #{io_current}"
        back << "#{host} disk.io[#{dev},io_time] #{time} #{io_time}"
        back << "#{host} disk.io[#{dev},io_weighted] #{time} #{io_weighted}"
        back << "#{host} disk.space[#{dev},size] #{time} #{size.to_i * 1000}"
        back << "#{host} disk.space[#{dev},used] #{time} #{used.to_i * 1000}"
        back << "#{host} disk.space[#{dev},available] #{time} #{available.to_i * 1000}"
        back << "#{host} disk.space[#{dev},percent_used] #{time} #{percent_used.gsub(/%/,'')}"
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
