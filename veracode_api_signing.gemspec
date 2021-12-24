# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "veracode_api_signing/version"

Gem::Specification.new do |spec|
  spec.name          = "veracode_api_signing"
  spec.version       = VeracodeApiSigning::VERSION
  spec.authors       = ["Corban Raun"]
  spec.email         = ["corban@raunco.co"]

  spec.summary       = "Veracode hmac signing library used with Veracode API"
  spec.homepage      = "https://CorbanR.github.io/veracode_api_signing"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://www.raunco.co/veracode_api_signing/"
  spec.metadata["source_code_uri"] = "https://github.com/CorbanR/veracode_api_signing"
  spec.metadata["changelog_uri"] = "https://github.com/CorbanR/veracode_api_signing/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features|examples|docs|coverage)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "brakeman", "~> 5.1"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.2"
  spec.add_development_dependency "rubocop-performance", "~> 1.1"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 2.5"
  spec.add_development_dependency "simplecov", "~> 0.21.2"
  spec.add_development_dependency "yard", "~> 0.9.26"
  spec.metadata = {
    "rubygems_mfa_required" => "true"
  }
end
