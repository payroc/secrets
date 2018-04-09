require 'aws-sdk-secretsmanager'
require 'secrets/manager'
require 'secrets/environment'

module Secrets
  class << self
    attr_accessor :instrumenter
  end

  module_function

  def load(secret_id)
    ignoring_nonexistent_secret do
      env = Environment.new(secret_id)
      instrument('secrets.load', env: env) { env.apply }
    end
  end

  # same as `load`, but raises
  # Aws::SecretsManager::Errors::ResourceNotFoundException if the secret doesn't exist
  def load!(secret_id)
    env = Environment.new(secret_id)
    instrument('secrets.load', env: env) { env.apply }
  end

  # same as `load`, but will override existing values in `ENV`
  def overload(secret_id)
    ignoring_nonexistent_secret do
      env = Environment.new(secret_id)
      instrument('secrets.overload', env: env) { env.apply! }
    end
  end

  def instrument(name, payload = {}, &block)
    if instrumenter
      instrumenter.instrument(name, payload, &block)
    else
      yield
    end
  end

  def ignoring_nonexistent_secret
    yield
  rescue Aws::SecretsManager::Errors::ResourceNotFoundException
  end
end
