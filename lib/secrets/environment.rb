module Secrets
  class Environment < Hash
    attr_reader :filename

    def initialize(secret_id)
      @secret_id = secret_id
      load
    end

    def load
      update Manager.call(@secret_id)
    end

    def apply
      each { |k, v| ENV[k] ||= v }
    end

    def apply!
      each { |k, v| ENV[k] = v }
    end
  end
end
