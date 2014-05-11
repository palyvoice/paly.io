require 'sinatra'
require './db'

class PalyIO < Sinatra::Base
  configure do
    @@host = "http://paly.io"

    def gen_rand size=6
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      (0...size).map{ charset.to_a[rand(charset.size)] }.join
    end

    def fetch_url key
      Link.first(:shortkey => key.upcase)
    end

    def key_exists? key
      fetch_url(key.upcase) != nil
    end

    def save_url key, url
      Link.create(:shortkey => key.upcase, :url => url)
    end

    def gen_key size=6, num_attempts=0
      attempt = gen_rand size
      if key_exists? attempt
        return gen_key size+1 if num_attempts > 9
        return gen_key size, num_attempts + 1
      else
        return attempt
      end
    end

    def valid_custom_key? key
      exp = /^([\w]|-){5,}$/ #five or more letters/digits/underscores/dashes

      return (key =~ exp) == 0 && !key_exists? key
    end
  end

  get '/' do
    erb :index
  end

  post '/shorten' do
    custom = params[:customurl].strip
    url = params[:url]
    url = "http://#{url}" unless url[/^https?/]

    if custom.strip.empty?
      key = gen_key
      save_url key, url
    elsif valid_custom_key? custom
      key = custom
      save_url key, url
    else
      key = "error"
    end
     
    "Your URL is <a target='_blank' href='#{@@host}/#{key}'>#{@@host}/#{key}</a>"
  end

  get '/:key' do
    redirect to fetch_url(params[:key]).url if key_exists? params[:key]
    redirect to "http://paly.io"
  end

  post '/postreceive' do
    `git pull origin master`
    `./restart.sh`
  end
end
