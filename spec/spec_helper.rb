# frozen_string_literal: true

require "bundler/setup"
require "webmock"
require "webmock/rspec"
require "pgrdsiam"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.before(:suite) do
  end
end
