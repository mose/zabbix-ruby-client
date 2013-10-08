# uses http://wiki.nginx.org/HttpStubStatusModule

class ZabbixRubyClient
  module Plugins
    module Nginx
      extend self

      def collect(*args)
        host = args[0]
        info = get_status

        time = Time.now.to_i
        back = []
        back << "#{host} nginx[total] #{time} #{ret[:total]}"
        back << "#{host} nginx[reading] #{time} #{ret[:reading]}"
        back << "#{host} nginx[writing] #{time} #{ret[:writing]}"
        back << "#{host} nginx[waiting] #{time} #{ret[:waiting]}"
        back << "#{host} nginx[accepted] #{time} #{ret[:accepted]}"
        back << "#{host} nginx[handled] #{time} #{ret[:handled]}"
        back << "#{host} nginx[requests] #{time} #{ret[:requests]}"
        return back
      end

      def get_status
        ret = {}
        open "http://127.0.0.1:8090/nginx_status" do |f|
          f.each_line do |line|
            ret[:total] = $1 if line =~ /^Active connections:\s+(\d+)/
            if line =~ /^Reading:\s+(\d+).*Writing:\s+(\d+).*Waiting:\s+(\d+)/
              ret[:reading] = $1
              ret[:writing] = $2
              ret[:waiting] = $3
            end
            ret[:accepted], ret[:handled], ret[:requests] = [$1, $2, $3] if line =~ /^\s+(\d+)\s+(\d+)\s+(\d+)/
          end
        end
        ret
      end

    end
  end
end

ZabbixRubyClient::Plugins.register('nginx', ZabbixRubyClient::Plugins::Nginx)
