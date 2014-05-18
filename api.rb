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
      valid, reason = valid_custom_key? custom

      return gen_validation_response valid, custom, reason
    end

    get '/meta' do
      key = params[:key]
      link = fetch_url key

      if link
        return gen_meta_response true, link, 'URL exists.'
      else
        return gen_meta_response false, nil, 'URL does not exist.'
      end
    end

    get '/whatis' do
      key = params[:key]
      link = fetch_url key

      if link
        return gen_whatis_response true, link.url, 'URL exists.'
      else
        return gen_whatis_response false, nil, 'URL does not exist.'
      end
    end

    get '/shorten' do
      custom = params[:custom].strip
      url = params[:url].strip

      if url.empty?
        return gen_shorten_response false, nil, 'Error: long URL is blank'
      end
      url = "http://#{url}" unless url[/^https?/]

      if custom.empty?
        key = gen_key
        save_url key, url
        return gen_shorten_response true, key, 'Auto generated key.'
      elsif valid_custom_key? custom
        key = custom
        save_url key, url
        return gen_shorten_response true, key, 'Custom URL valid.'
      else
        return gen_shorten_response false, nil, 'Error generating custom URL. Please try another.'
      end
    end

    get '/qr' do
      gen_qr_code_response true, "#{@@host}/#{params[:key]}".to_qr(:size => '250x250'), 'Not confirming that this is valid.'
    end
  end
end
