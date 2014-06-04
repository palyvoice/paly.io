require 'rack/throttle'
require 'rack/cors'

require './patches'
require './app'
require './api'

use Rack::Throttle::Hourly, :max => 120

use Rack::Cors do
  allow do
    origins '*'
    resource '/api/*'
  end
end

map '/' do
  run PalyIO::Web
end

map '/api' do
  run PalyIO::API
end
