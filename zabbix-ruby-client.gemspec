# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zabbix-ruby-client/version'

Gem::Specification.new do |spec|
  spec.name          = "zabbix-ruby-client"
  spec.version       = ZabbixRubyClient::VERSION
  spec.authors       = ["mose"]
  spec.email         = ["mose@mose.com"]
  spec.description   = %q{A zabbix alternative to zabbix-agent using zabbix-sender.}
  spec.summary       = %q{This tool is intended to use zabbix sender to propagate monitoring data for Zabbix server.}
  spec.homepage      = "https://github.com/eduvo/zabbix-ruby-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
