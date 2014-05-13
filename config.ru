require './before'
require './app'
require './api'

map '/' do
  run PalyIO::Web
end

map '/api' do
  run PalyIO::API
end
