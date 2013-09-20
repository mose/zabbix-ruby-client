class ZabbixRubyClient
  module Plugins
    extend self

    def load_dirs(dirs)
      @available = {}
      @loaded = {}
      dirs.each do |d|
        Dir.glob(File.join(d,"*.rb")).reduce(@available) { |a,x|
          name = File.basename(x,".rb")
          a[name] = x
          a
        }
      end
    end

    def register(plugin, klass)
      @loaded[plugin] = klass
    end

    def loaded
      @loaded ||= {}
    end

    def load(plugin)
      if @loaded[plugin]
        true
      else
        if @available[plugin]
          ZabbixRubyClient.send :load, @available[plugin]
        else
          nil
        end
      end
    end

  end
end