require 'secrets'

# Fix for rspec rake tasks loading in development
#
# Secrets loads environment variables when the Rails application is initialized.
# When running `rake`, the Rails application is initialized in development.
# Rails includes some hacks to set `RAILS_ENV=test` when running `rake test`,
# but rspec does not include the same hacks.
#
# See https://github.com/bkeepers/secrets/issues/219
if defined?(Rake.application)
  is_running_specs = Rake.application.top_level_tasks.grep(/^spec(:|$)/).any?
  Rails.env = ENV['RAILS_ENV'] ||= 'test' if is_running_specs
end

Secrets.instrumenter = ActiveSupport::Notifications

# Watch all loaded env files with Spring
begin
  require 'spring/commands'
  ActiveSupport::Notifications.subscribe(/^secrets/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename if Rails.application
  end
rescue LoadError
  # Spring is not available
end

module Secrets
  # Secrets Railtie for using Secrets to load environment from a file into
  # Rails applications
  class Railtie < Rails::Railtie
    # Public: Load secrets
    #
    # This will get called during the `before_configuration` callback, but you
    # can manually call `Secrets::Railtie.load` if you needed it sooner.
    def load
      Secrets.load(*secrets_files)
    end

    # Internal: `Rails.root` is nil in Rails 4.1 before the application is
    # initialized, so this falls back to the `RAILS_ROOT` environment variable,
    # or the current working directory.
    def root
      Rails.root || Pathname.new(ENV['RAILS_ROOT'] || Dir.pwd)
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end

    config.before_configuration { load }

    private

    def secrets_files
      [
        root.join(".env.#{Rails.env}.local"),
        (root.join('.env.local') unless Rails.env.test?),
        root.join(".env.#{Rails.env}"),
        root.join('.env')
      ].compact
    end
  end
end
