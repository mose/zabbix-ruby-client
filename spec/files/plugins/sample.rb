module Sample
  extend self

  def collect(*args)
    return ["localhost sample[foo] 123456789 42"]
  end

end

ZabbixRubyClient::Plugins.register('sample', Sample)

