require 'rack/throttle'

require './before'
require './app'
require './api'

use Rack::Throttle::Hourly, :max => 120

map '/' do
  run PalyIO::Web
end

map '/api' do
  run PalyIO::API
end
