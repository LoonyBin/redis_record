# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis_record/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Subhash Chandra"]
  gem.email         = ["TMaYaD@LoonyB.in"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "redis_record"
  gem.require_paths = ["lib"]
  gem.version       = RedisRecord::VERSION
end
