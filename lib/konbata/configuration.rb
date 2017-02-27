# Copyright (C) 2017  Atomic Jolt
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "yaml"

module Konbata
  class Configuration
    attr_reader :canvas_url
    attr_reader :canvas_token
    attr_reader :account_id
    attr_reader :scorm_url
    attr_reader :scorm_launch_url
    attr_reader :scorm_shared_auth
    attr_reader :request_timeout
    attr_reader :libre_office_path
    DEFAULT_TIMEOUT = 1_800 # 30 minutes

    def initialize
      @canvas_url = Configuration._config[:canvas_url]
      @canvas_token = Configuration._config[:canvas_token]
      @account_id = Configuration._config[:account_id] || :self
      @scorm_url = Configuration._config[:scorm_url]
      @scorm_launch_url = Configuration._config[:scorm_launch_url]
      @scorm_shared_auth = Configuration._config[:scorm_shared_auth]
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
