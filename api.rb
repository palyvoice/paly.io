require 'grape'
require './db'
require './helpers'

class PalyIO
  class API < Grape::API
    format :json

    params do
      requires :key, :type => String, :desc => 'URL key.'
    end
    group do
      get '/validate' do
        key = params[:key].strip
        valid, reason = valid_key? key

        return gen_validate_response valid, key, reason
      end

      get '/meta' do
        key = params[:key]
        link = fetch_url key

        if link
          # Gets the hit objects then changes the name in the resulting hash
          modified = link.with_attributes(:hit_objs).attribute_replace(:hit_objs, :hits)
          return gen_meta_response true, modified, 'URL exists.'
        else
          return gen_meta_response false, nil, 'URL does not exist.'
        end
      end

      get '/stats' do
        key = params[:key]
        link = fetch_url key

        if link
          return gen_stats_response true, build_stats(link), 'URL exists.'
        else
          return gen_stats_response false, nil, 'URL does not exist.'
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

      get '/qr' do
        gen_qr_response true, "#{host}/#{params[:key]}".to_qr(:size => '250x250'), 'Not confirming that this is valid.'
      end
    end # end group

    params do
      optional :custom, :type => String, :desc => 'Custom url key.'
      requires :url, :type => String, :desc => 'URL to be shortened.'
    end
    get '/shorten' do
      custom, url = params[:custom].strip, params[:url].strip

      if url.empty?
        return gen_shorten_response false, nil, 'Long URL is blank'
      end

      url, type = classify_long url
      valid, reason = valid_custom_key? custom

      if custom.empty?
        key = gen_key
        save_url key, url
        return gen_shorten_response true, key, 'Auto generated key.'
      elsif valid
        key = custom
        save_url key, url
        return gen_shorten_response true, key, reason
      else
        return gen_shorten_response false, nil, reason
      end
    end # end shorten
  end # end API
end # end PalyIO
