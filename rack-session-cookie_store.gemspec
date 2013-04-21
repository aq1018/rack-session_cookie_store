# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rack/session/cookie_store/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-session-cookie_store"
  gem.version       = Rack::CookieStore::VERSION
  gem.authors       = ["Aaron Qian"]
  gem.email         = ["aq1018@gmail.com"]
  gem.description   = %q{ a better cookie session store for rack. }
  gem.summary       = %q{ Uses JSON to store session data and signed with sha256. cookie is compatible with node.js connect middleware. }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rack', '~> 1.4.5'
end
