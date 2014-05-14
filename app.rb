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
      redirect to fetch_url(params[:key]).url if key_exists? params[:key]
      'URL does not exist'
    end

    get '/qr/:key' do
      content_type 'image/png'
      qr = open("#{@@host}/#{params[:key]}".to_qr(:size => '250x250'))
      qr.read
    end

    post '/postreceive' do
      `git pull origin master`
      `./scripts/restart.sh`
    end
  end
end
