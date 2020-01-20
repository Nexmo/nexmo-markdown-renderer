$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require_relative "lib/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "nexmo_markdown_renderer"
  spec.version     = Nexmo::Markdown::VERSION
  spec.authors     = ["Nexmo"]
  spec.email       = ["devrel@nexmo.com"]
  spec.homepage    = "https://github.com/Nexmo/nexmo-markdown-renderer"
  spec.summary     = "Middleware to render Markdown Documents in Nexmo Developer Platform."
  spec.description = "Middleware to render Markdown Documents in Nexmo Developer Platform."
  spec.license     = "MIT"

  spec.files = Dir["{lib}/**/*", "LICENSE.txt", "README.md"]

  spec.add_runtime_dependency('banzai', '~> 0.1.2')
  spec.add_runtime_dependency('octicons_helper', '~> 9.3')
  spec.add_runtime_dependency('nokogiri', '~> 1.10')
  spec.add_runtime_dependency('redcarpet', '~> 3.5')
  spec.add_runtime_dependency('rouge', '~> 3.15')
  spec.add_runtime_dependency('activemodel', '~> 6.0')
  spec.add_runtime_dependency('i18n', '~> 0.9')
  spec.add_development_dependency('simplecov', '~> 0.16')
  spec.add_development_dependency('coveralls', '~> 0.8.15')
  spec.add_development_dependency('rspec', '~> 3.9')
  spec.add_development_dependency('rspec-rails', '~> 3.7')
  spec.add_development_dependency('rspec-collection_matchers')
  spec.add_development_dependency('rspec-snapshot', '~> 0.1.2')
  spec.add_development_dependency('byebug')

  spec.metadata = {
    'homepage' => 'https://github.com/Nexmo/nexmo-markdown-renderer',
    'source_code_uri' => 'https://github.com/Nexmo/nexmo-markdown-renderer',
    'bug_tracker_uri' => 'https://github.com/Nexmo/nexmo-markdown-renderer/issues',
    'changelog_uri' => 'https://github.com/Nexmo/nexmo-markdown-renderer/blob/master/CHANGES.md'
  }
end

