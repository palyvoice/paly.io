require 'google-qr'
require 'open-uri'
require 'sinatra'
require './db'
require './patches'
require './helpers'

class PalyIO
  class Web < Sinatra::Base
    get '/' do
      erb :index
    end

    get '/:key' do
      if key_exists? params[:key]
        l = fetch_url params[:key]
        h = Hit.create :link => l
        redirect to l.url
      end
      'URL does not exist'
    end

    get '/qr/:key' do
      content_type 'image/png'
      qr = open "#{host}/#{params[:key]}".to_qr(:size => '250x250')
      qr.read
    end

    post '/postreceive' do
      `git pull origin master`
      `bundle install`
      `sleep 5`
      `./scripts/restart.sh`
    end
  end
end
