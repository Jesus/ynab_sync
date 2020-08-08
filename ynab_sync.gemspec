
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ynab_sync/version"

Gem::Specification.new do |spec|
  spec.name          = "ynab_sync"
  spec.version       = YnabSync::VERSION
  spec.authors       = ["Jesus Burgos Macia"]
  spec.email         = ["jburmac@gmail.com"]

  spec.summary       = %q{Keep YNAB in sync with the bank}
  spec.homepage      = "https://github.com/Jesus/ynab_sync"
  spec.license       = "MIT"

  unless spec.respond_to?(:metadata)
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"

  spec.add_dependency "plaid"
  spec.add_dependency "ynab"
  spec.add_dependency "activesupport"
end
