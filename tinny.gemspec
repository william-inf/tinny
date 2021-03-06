
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tinny/version"

Gem::Specification.new do |spec|
  spec.name          = "tinny"
  spec.version       = Tinny::VERSION
  spec.authors       = ["william-inf"]
  spec.email         = ["me@williamthom.as"]

  spec.summary       = "CAN decoding utils for hacking the canbus!"
  spec.description   = "A variety of helper utilities for CAN decoding."
  spec.homepage      = "http://wwww.williamthom.as"
  spec.license       = "MIT"
  spec.executables   = ["tinny"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "serialport", "1.3.1"
  spec.add_development_dependency "celluloid", "0.17.3"
  spec.add_development_dependency "timers", "4.1.2"
  spec.add_development_dependency "firehose", "0.1.0"
  spec.add_development_dependency "influxdb", "0.5.2"

end
