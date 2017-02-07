require "yaml"

module Konbata
  class Configuration
    attr_reader :libre_office_path

    def initialize
      @libre_office_path = Configuration.config[:libre_office_path]
    end

    def self.config
      @config ||= if File.exists? "konbata.yml"
                    YAML::safe_load(File.read("konbata.yml"), [Symbol])
                  else
                    {}
                  end
    end
  end
end
