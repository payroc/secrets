require File.expand_path('../lib/secrets/version', __FILE__)
require 'English'

Gem::Specification.new 'secrets', Secrets::VERSION do |gem|
  gem.authors       = ['Tim Hogg']
  gem.email         = ['thogg4@gmail.com']
  gem.description   = gem.summary = 'Loads environment variables from AWS Secrets Manager.'
  gem.homepage      = 'https://github.com/bkeepers/secrets'
  gem.license       = 'MIT'

  gem_files         = `git ls-files README.md LICENSE lib bin | grep -v rails`
  gem.files         = gem_files.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  gem.add_dependency 'aws-sdk-secretsmanager'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop', '~>0.54.0'
end
