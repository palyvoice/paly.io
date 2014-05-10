require 'sinatra'
require './db'

class PalyIO < Sinatra::Base
  configure do
    @@host = "http://url.palyvoice.com"

    def gen_rand size=6
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      (0...size).map{ charset.to_a[rand(charset.size)] }.join
    end

    def fetch_url key
      Link.first(:shortkey => key)
    end

    def key_exists? key
      fetch_url(key) != nil
    end

    def save_url key, url
      Link.create(:shortkey => key, :url => url)
    end

    def gen_key size=6
      attempt = gen_rand size
      if key_exists? attempt
        gen_key size+1
      else
        return attempt
      end
    end
  end

  get '/' do
    erb :index
  end

  post '/shorten' do
    url = params[:url]
    url = "http://#{url}" unless url[/^https?/]

    key = gen_key
    save_url key, url
    "Your URL is <a target='_blank' href='#{@@host}/#{key}'>#{@@host}/#{key}</a>"
  end

  get '/:key' do
    redirect to fetch_url params[:key]
  end

  post '/postreceive' do
    `git pull origin master`
    `./restart.sh`
  end
end
