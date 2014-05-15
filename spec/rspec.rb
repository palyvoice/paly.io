require 'rack/test'
require 'minitest/autorun'
require 'ffaker'
require 'spec_helper'
require './api'

describe PalyIO::API do
  include Rack::Test::Methods

  def app
    PalyIO::API
  end

  before(:all) do
#    @@browser = Selenium::WebDriver.for(:chrome)
  end

  before(:each) do
#    @@browser.get(ENV['PALYIO_HOSTNAME'])
  end

  context :api do
    describe 'GET /shorten' do
      it 'shortens a given url' do
        get '/shorten', { :url => Faker::Internet.http_url, :custom => "" }
        hash = JSON.parse(last_response.body)
        hash['success'].should == true
      end
    end

    describe 'GET /whatis' do
      it 'gets the url for a given key' do
        get '/whatis', { :key => 'buttface' }
      end
    end
  end
end
