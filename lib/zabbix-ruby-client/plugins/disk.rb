class ZabbixRubyClient
  module Plugins
    module Disk
      extend self

      def collect(*args)
        host = args[0]
        dev = args[1]
        diskinfo = `iostat -dx #{dev} | grep "^#{dev}"`
        if $?.to_i == 0
          _, rrqm, wrqm, r, w, rkb, wkb, avgrq, avgqu, await, rawait, wawait, svctm, util = diskinfo.split(/\s+/)
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

        time = Time.mow.to_i
        back = []
        back << "#{host} disk.io[#{dev},read_req_per_sec] #{time} #{rrqm}"
        back << "#{host} disk.io[#{dev},write_req_per_sec] #{time} #{wrqm}"
        back << "#{host} disk.io[#{dev},read_per_sec] #{time} #{r}"
        back << "#{host} disk.io[#{dev},write_per_sec] #{time} #{w}"
        back << "#{host} disk.io[#{dev},read_sector_per_sec] #{time} #{rkb}"
        back << "#{host} disk.io[#{dev},write_sector_per_sec] #{time} #{wkb}"
        back << "#{host} disk.io[#{dev},avg_sector_size] #{time} #{avgrq}"
        back << "#{host} disk.io[#{dev},avg_queue_length] #{time} #{avgqu}"
        back << "#{host} disk.io[#{dev},time_waiting] #{time} #{await}"
        back << "#{host} disk.io[#{dev},time_waiting_read] #{time} #{rawait}"
        back << "#{host} disk.io[#{dev},time_waiting_write] #{time} #{wawait}"
        back << "#{host} disk.io[#{dev},service_time] #{time} #{svctm}"
        back << "#{host} disk.io[#{dev},percent_util] #{time} #{util}"
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
