require 'secrets/substitutions/variable'
require 'secrets/substitutions/command'

module Secrets
  class Manager

    @substitutions = [Secrets::Substitutions::Variable, Secrets::Substitutions::Command]

    class << self
      attr_reader :substitutions

      def call(secret_id)
        new(secret_id).call
      end
    end

    def initialize(secret_id)
      @secret_id = secret_id
      @sm = Aws::SecretsManager::Client.new
      @unsubbed = fetch_secret
      @subbed = {}
    end

    def call
      @unsubbed.each do |key, value|
        sub(key, value)
      end
      @subbed
    end

    private

    def fetch_secret
      JSON.parse(@sm.get_secret_value(secret_id: @secret_id).secret_string)
    end

    def sub(key, value)
      @subbed[key] = parse_value(value)
    end

    def parse_value(value)
	  self.class.substitutions.each do |proc|
		value = proc.call(value, @subbed)
	  end
      value
    end

  end
end
