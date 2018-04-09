require File.expand_path('../lib/secrets/version', __FILE__)
require 'English'

Gem::Specification.new 'secrets-rails', Secrets::VERSION do |gem|
  gem.authors       = ['Tim Hogg']
  gem.email         = ['thogg4@gmail.com']
  gem.description   = gem.summary = 'Autoload secrets from AWS Secrets Manager in Rails.'
  gem.homepage      = 'https://github.com/thogg4/secrets'
  gem.license       = 'MIT'
  gem.files         = `git ls-files lib | grep rails`.split(
    $OUTPUT_RECORD_SEPARATOR
  ) + ['README.md', 'LICENSE']

  gem.add_dependency 'secrets', Secrets::VERSION
  gem.add_dependency 'railties', '>= 3.2', '< 5.2'

  gem.add_development_dependency 'spring'
end
