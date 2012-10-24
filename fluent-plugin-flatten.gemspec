# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-flatten"
  gem.version       = "0.0.1"
  gem.authors       = ["aki"]
  gem.email         = ["lala.akira@gmail.com"]
  gem.description   = %q{Output filter plugin flatten a nested json}
  gem.summary       = %q{Output filter plugin flatten a nested json}
  gem.homepage      = "https://github.com/aki77/fluent-plugin-flatten"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "fluentd"
  gem.add_runtime_dependency "fluentd"
end
