# If you use gems that require environment variables to be set before they are
# loaded, then list `secrets-rails` in the `Gemfile` before those other gems and
# require `secrets/rails-now`.
#
#     gem 'secrets-rails', require: 'secrets/rails-now'
#     gem 'gem-that-requires-env-variables'
#

require 'secrets/rails'
Secrets::Railtie.load
