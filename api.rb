require 'grape'
require './db'
require './patches'
require './helpers'

class PalyIO
  class API < Grape::API
    format :json

    get '/validate' do
      custom = params[:custom].strip
      valid, reason = valid_custom_key? custom

      return gen_validate_response valid, custom, reason
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

      stats = {
        :key => key,
        :created_at => link.created_at,
        :hit_count => link.hit_objs.length,
        :hits => link.hit_objs
      }

      if link
        return gen_stats_response true, stats, 'URL exists.'
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

    get '/shorten' do
      custom = params[:custom].strip
      url = params[:url].strip

      if url.empty?
        return gen_shorten_response false, nil, 'Long URL is blank'
      end
      url = "http://#{url}" unless url[/^https?/]

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
    end

    get '/qr' do
      gen_qr_response true, "#{host}/#{params[:key]}".to_qr(:size => '250x250'), 'Not confirming that this is valid.'
    end
  end
end
