Load environment variables from AWS Secrets Manager into `ENV`.

Storing [configuration in the environment](http://12factor.net/config) is one of the tenets of a [twelve-factor app](http://12factor.net). Anything that is likely to change between deployment environments–such as resource handles for databases or credentials for external services–should be extracted from the code into environment variables.

Secrets loads variables from AWS Secrets Manager into `ENV` when the environment is bootstrapped.

## Installation

### Rails

Add this line to the top of your application's Gemfile:

```ruby
gem 'secrets-rails', groups: [:development, :test]
```

And then execute:

```shell
$ bundle
```

#### Note on load order

Secrets is initialized in your Rails app during the `before_configuration` callback, which is fired when the `Application` constant is defined in `config/application.rb` with `class Application < Rails::Application`. If you need it to be initialized sooner, you can manually call `Secrets::Railtie.load`.

```ruby
# config/application.rb
Bundler.require(*Rails.groups)

Secrets::Railtie.load

HOSTNAME = ENV['HOSTNAME']
```

If you use gems that require environment variables to be set before they are loaded, then list `secrets-rails` in the `Gemfile` before those other gems and require `secrets/rails-now`.

```ruby
gem 'secrets-rails', require: 'secrets/rails-now'
gem 'gem-that-requires-env-variables'
```

### Sinatra or Plain ol' Ruby

Install the gem:

```shell
$ gem install secrets
```

As early as possible in your application bootstrap process:

```ruby
require 'secrets'
Secrets.load
```

By default, `load` will look for a secret in AWS Secrets Manager with the same name as the current working application. Pass in a string if your secret does not use the name of your app.

```
require 'secrets'
Secrets.load('fancy_name')
```

To ensure `.env` is loaded in rake, load the tasks: TODO

```ruby
require 'secrets/tasks'

task mytask: :secrets do
    # things that require .env
end
```

## Usage

Add your application configuration to a secret in AWS Secrets Manager:

```shell
S3_BUCKET=YOURS3BUCKET
SECRET_KEY=YOURSECRETKEYGOESHERE
```

Whenever your application loads, these variables will be available in `ENV`:

```ruby
config.fog_directory  = ENV['S3_BUCKET']
```

### Command Substitution TODO

You need to add the output of a command in one of your variables? Simply add it with `$(your_command)`:

```shell
DATABASE_URL="postgres://$(whoami)@localhost/my_database"
```

### Variable Substitution TODO

You need to add the value of another variable in one of your variables? You can reference the variable with `${VAR}` or often just `$VAR` in unqoted or double-quoted values.

```shell
DATABASE_URL="postgres://${USER}@localhost/my_database"
```

If a value contains a `$` and it is not intended to be a variable, wrap it in single quotes.

```shell
PASSWORD='pas$word'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
