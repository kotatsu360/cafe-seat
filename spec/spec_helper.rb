# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'rspec'
require 'rack/test'

module RSpecMixin

  include Rack::Test::Methods
  def app() CafeSeat::Server end

end

RSpec.configure do |config|

  config.include RSpecMixin

  config.fail_fast = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
