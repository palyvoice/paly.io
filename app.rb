require 'google-qr'
require 'open-uri'
require 'sinatra'
require './db'
require './helpers'

class PalyIO
  class Web < Sinatra::Base
    configure do
      @@host = ENV['PALYIO_HOSTNAME']
    end

    get '/' do
      erb :index
    end

    get '/:key' do
      if key_exists? params[:key]
        l = fetch_url(params[:key])
        hits = l.hits
        l.update(:hits => hits + 1)
        redirect to l.url
      end
      'URL does not exist'
    end

    get '/qr/:key' do
      content_type 'image/png'
      qr = open("#{@@host}/#{params[:key]}".to_qr(:size => '250x250'))
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
