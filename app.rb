# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/json'
require "sinatra/reloader"
require 'sinatra/activerecord'

Time.zone = "Tokyo"
ActiveRecord::Base.default_timezone = :local

ActiveRecord::Base.configurations = YAML::load(ERB.new(IO.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(:ENV['RACK_ENV'])

module CafeSeat
  class Server < Sinatra::Base
    set :environments, %w{development test production}

    configure do
      register Sinatra::Reloader
    end

    use ActiveRecord::ConnectionAdapters::ConnectionManagement

    helpers do
      def h(text)
        Rack::Utils.escape_html(text)
      end
    end

    before do
      content_type :json
    end
    set :json_content_type, :js

    get '/?' do
      json({ message: 'hello :)' })
    end
  end
end
