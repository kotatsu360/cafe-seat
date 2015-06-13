# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/param'

require_relative 'models/init'

require 'pusher'

Time.zone = "Tokyo"
ActiveRecord::Base.default_timezone = :local

ActiveRecord::Base.configurations = YAML::load(ERB.new(IO.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(:ENV['RACK_ENV'])

module CafeSeat
  class Server < Sinatra::Base
    helpers Sinatra::Param
    set :environments, %w{development test production}

    configure do
      register Sinatra::Reloader
    end

    use ActiveRecord::ConnectionAdapters::ConnectionManagement

    helpers do
      def h(text)
        Rack::Utils.escape_html(text)
      end

      def pusher(channel)
        Pusher.url = "http://e0c0b870bbeeb89ccfcb:439af28f5229fe0d362e@api.pusherapp.com/apps/124786"
        Pusher[channel]
      end
    end

    before do
      content_type :json
    end
    set :json_content_type, :js

    get '/?' do
      json({ message: 'hello :)' })
    end

    post '/regist/?' do
      param :uuid, String, required: true
      param :device, String, required: true

      CurrentLocation.create(uuid: params[:uuid],
                             device: params[:device])

      # Place.find_by(uuid: params[:uuid])
      # json({place: Place.name})
      json({})
    end

    get '/order/?' do
      param :price, Integer, required: true
      param :keyword, String, required: true

      # p Place.where(keyword: params[:keyword])
      # p place = Place.where(keyword: params[:keyword]).first

      uuid = 'test_channel' # place.uuid

      # [NOTE] チャンネル=お店
      pusher(uuid).trigger('my_event', {
                                       message: "#{params[:price]}円で席欲しい人がいるです"
                                     })
    end
  end
end
