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

require_relative "helpers/spec_helper"
require "konbata/configuration"

describe Konbata::Configuration do
  before do
    @config = Konbata::Configuration.new
  end

  it "has a canvas_url attribute" do
    assert_respond_to(@config, :canvas_url)
  end

  it "has a canvas_token attribute" do
    assert_respond_to(@config, :canvas_token)
  end

  it "has a account_id attribute" do
    assert_respond_to(@config, :account_id)
  end

  it "has a scorm_url attribute" do
    assert_respond_to(@config, :scorm_url)
  end

  it "has a scorm_launch_url attribute" do
    assert_respond_to(@config, :scorm_launch_url)
  end

  it "has a scorm_shared_auth attribute" do
    assert_respond_to(@config, :scorm_shared_auth)
  end

  it "has a request_timeout attribute" do
    assert_respond_to(@config, :request_timeout)
  end
end
