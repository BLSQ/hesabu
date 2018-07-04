
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hesabu/version"

Gem::Specification.new do |spec|
  spec.name          = "hesabu"
  spec.version       = Hesabu::VERSION
  spec.authors       = ["Stéphan Mestach"]
  spec.email         = ["smestach@bluesquarehub.com"]

  spec.summary       = "arithmetic equation solver."
  spec.description   = "arithmetic equation solver."
  spec.homepage      = "https://github.com/BLSQ/hesabu"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pronto"
  spec.add_development_dependency "pronto-flay"
  spec.add_development_dependency "pronto-rubocop"
  spec.add_development_dependency "pronto-simplecov"
  spec.add_development_dependency "simplecov"
end
