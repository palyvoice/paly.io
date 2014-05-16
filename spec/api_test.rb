require 'rack/test'
require 'minitest/autorun'
require 'ffaker'
require 'spec_helper'
require 'awesome_print'
require 'json'
require './api'

describe PalyIO::API do
  include Rack::Test::Methods

  def app
    PalyIO::API
  end

  def gen_link key, url
    Link.create :shortkey => key, :url => url
  end

  def link_hash link
    link.attributes.with_indifferent_access
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
        link = link_hash gen_link(key, url)

        get '/whatis', { :key => key }

        hash = JSON.parse(last_response.body)
        hash['success'].should == true
        hash['response'].should == url
      end
    end

    describe 'GET /meta' do
      it 'gets the meta information for a given key' do
        url = Faker::Internet.http_url
        key = Faker.numerify("######")
        link = link_hash gen_link(key, url)

        get '/meta', { :key => key }

        hash = JSON.parse(last_response.body)
        hash['success'].should == true
        hash['response'].should == link
      end
    end

    describe 'GET /validate' do
      it 'makes sure a valid key is valid' do
        custom = Faker.numerify("######")

        get '/validate', { :custom => custom }

        hash = JSON.parse(last_response.body)
        hash['success'].should == true
        hash['response'].should == custom
      end
    end

    describe 'GET /validate' do
      it 'makes sure an invalid key is invalid' do
        custom = Faker.numerify("####")

        get '/validate', { :custom => custom }

        hash = JSON.parse(last_response.body)
        hash['success'].should == false
        hash['response'].should == custom
      end
    end
  end
end
