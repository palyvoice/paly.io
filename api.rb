require 'grape'
require './db'
require './helpers'

class PalyIO
  class API < Grape::API
    format :json

    helpers do
      @@host = ENV['PALYIO_HOSTNAME']
    end

    get '/validate' do
      custom = params[:custom].strip

      if valid_custom_key? custom
        return gen_validation_response true, custom, "Valid key."
      else
        return gen_validation_response false, custom, "Invalid key."
      end
    end

    get '/whatis' do
      key = params[:key]
      link = fetch_url key
      if link
        return gen_whatis_response true, link.url, "URL exists."
      else
        return gen_whatis_response false, nil, "URL does not exist."
      end
    end

    get '/shorten' do
      custom = params[:custom].strip
      url = params[:url]
      url = "http://#{url}" unless url[/^https?/]

      if custom.strip.empty?
        key = gen_key
        save_url key, url
        return gen_shorten_response true, key, "Auto generated key."
      elsif valid_custom_key? custom
        key = custom
        save_url key, url
        return gen_shorten_response true, key, "Custom URL valid."
      else
        return gen_shorten_response false, nil, "Error generating custom URL. Please try another."
      end
    end
  end
end
