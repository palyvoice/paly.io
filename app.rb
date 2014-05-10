require 'sinatra'
require 'redis'

class PalyIO < Sinatra::Base
  configure do
    @@redis = Redis.new
    @@host = "http://url.palyvoice.com"

    def gen_rand size=6
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      (0...size).map{ charset.to_a[rand(charset.size)] }.join
    end

    def key_exists? key
      @@redis.get(key.downcase) != nil
    end

    def gen_key size=6
      attempt = gen_rand size
      if key_exists? attempt
        gen_key size+1
      else
        return attempt
      end
    end

    def save_url key, url
      @@redis.set key, url
    end

    def fetch_url key
      @@redis.get key
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
  end
end
