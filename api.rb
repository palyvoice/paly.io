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
  end
end
