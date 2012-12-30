# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis_record/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Subhash Chandra"]
  gem.email         = ["TMaYaD@LoonyB.in"]
  gem.description   = %q{Active model interface for redis}
  gem.summary       = %q{Active record like interface for redis without adding bloat}
  gem.homepage      = "http://github.com/loonybin/redis_record"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "redis_record"
  gem.require_paths = ["lib"]
  gem.version       = RedisRecord::VERSION

  gem.add_runtime_dependency 'active_attr'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'redis'
end
