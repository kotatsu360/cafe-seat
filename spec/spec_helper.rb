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

shared_examples_for '必須パラメータ' do |name|

  it "#{name}" do
    params.delete(target.intern)

    if method == 'get'
      get uri+'?'+params.to_query
    elsif method == 'post'
      post uri, params
    end
    expect(json['errors'][target]).to eq('Parameter is required')
  end
end
