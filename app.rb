require 'sinatra'
require 'google-qr'
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
      "#{@@host}/#{params[:key]}".to_qr_image :size => '250x250'
    end

    post '/postreceive' do
      `git pull origin master`
      `bundle install`
      `./scripts/restart.sh`
    end
  end
end
