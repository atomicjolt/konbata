require "yaml"

module Konbata
  class Configuration
    attr_accessor :canvas_url
    attr_accessor :canvas_token
    attr_accessor :account_id
    attr_accessor :request_timeout
    attr_reader :libre_office_path
    DEFAULT_TIMEOUT = 1_800 # 30 minutes

    def initialize
      @canvas_url = Configuration._config[:canvas_url]
      @canvas_token = Configuration._config[:canvas_token]
      @account_id = Configuration._config[:account_id] || :self
      @request_timeout =
        Configuration._config[:request_timeout] || DEFAULT_TIMEOUT
      @libre_office_path = Configuration._config[:libre_office_path]
    end

    def self._config
      @config ||= if File.exists? "konbata.yml"
                    YAML::safe_load(File.read("konbata.yml"), [Symbol])
                  else
                    {}
                  end
    end
  end
end
