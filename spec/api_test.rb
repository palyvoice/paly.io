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
        url = Faker::Internet.http_url
        key = Faker.numerify("######")
        Link.create(:shortkey => key, :url => url)

        get '/whatis', { :key => key }
        hash = JSON.parse(last_response.body)
        hash['success'].should == true
        hash['response'].should == url
      end
    end
  end
end
