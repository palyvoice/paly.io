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

    post '/shorten' do
      custom = params[:custom].strip
      url = params[:url]
      url = "http://#{url}" unless url[/^https?/]

      if custom.strip.empty?
        key = gen_key
        save_url key, url
      elsif valid_custom_key? custom
        key = custom
        save_url key, url
      else
        return "Error generating custom URL. Please try another."
      end

      "Your URL is <a target='_blank' href='#{@@host}/#{key}'>#{@@host}/#{key}</a>"
    end

    get '/:key' do
      redirect to fetch_url(params[:key]).url if key_exists? params[:key]
      "URL does not exist"
    end

    post '/postreceive' do
      `git pull origin master`
      `bundle install`
      `./scripts/restart.sh`
    end
  end
end
