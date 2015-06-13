# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/param'
require 'sinatra/cross_origin'

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
      register Sinatra::CrossOrigin
      enable :cross_origin
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
      param :device, String, required: true # 売る側

      # CurrentLocation.create(uuid: params[:uuid],
      #                        device: params[:device])

      # Place.find_by(uuid: params[:uuid])
      # json({place: Place.name})
      json({})
    end

    post '/order/?' do
      param :price, Integer, required: true
      param :keyword, String, required: true
      param :device, String, required: true # 買う側

      # [NOTE]とりあえず適当に
      location = CurrentLocation.first;
      unless location.nil?
        Order.create(uuid: location.uuid,
                     price: params[:price],
                     device: params[:device], # 買う側
                     )
        # [NOTE] チャンネル=お店
        pusher(location.uuid).trigger('order', {
                                        message: "#{params[:price]}円で席欲しい人がいるです"
                                      })
      end
      json({room: params[:device]})      # 返答が返ってくる部屋
    end

    get '/accept/?' do
      param :device, String, required: true # 売る側
      param :uuid, String, required: true

      order = Order.find_by(uuid: location.uuid);

      pusher(order.device).trigger('order', {
                                      message: "オッケーだってさ"
                                    })

      json({})
    end
  end
end
