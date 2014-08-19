require File.expand_path('../lib/fleet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = %w(CenturyLink)
  gem.email         = %w(clt-labs-futuretech@centurylink.com)
  gem.description   = 'A simple REST client for the CoreOS Fleet API'
  gem.summary       = 'A simple REST client for the CoreOS Fleet API'
  gem.homepage      = 'https://github.com/centurylinklabs/fleet-api'
  gem.license       = 'Apache 2'
  gem.platform      = Gem::Platform::RUBY
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'fleet-api'
  gem.require_paths = %w(lib)
  gem.version       = Fleet::VERSION
  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'faraday', '= 0.8.9'
  gem.add_dependency 'faraday_middleware', '= 0.9.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'simplecov', '~> 0.9.0'
  gem.add_development_dependency 'simplecov-rcov', '~> 0.2.3'
end
