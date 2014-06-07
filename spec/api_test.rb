require 'json'
require 'spec_helper'

describe PalyIO::API do
  include Rack::Test::Methods

  def app
    PalyIO::API
  end

  context :api do
    describe 'GET /shorten' do
      it 'shortens a given url' do
        get '/shorten', { :url => Faker::Internet.http_url, :custom => '' }

        hash = last_hash
        hash['success'].should == true
      end
    end

    describe 'GET /whatis' do
      it 'gets the url for a given key' do
        url = Faker::Internet.http_url
        key = Faker.numerify('######')
        link = link_hash gen_link(key, url)

        get '/whatis', { :key => key }

        hash = last_hash
        hash['success'].should == true
        hash['response'].should == url
      end
    end

    describe 'GET /meta' do
      it 'gets the meta information for a given key' do
        url = Faker::Internet.http_url
        key = Faker.numerify('######')
        link = link_hash gen_link(key, url)

        get '/meta', { :key => key }

        hash = last_hash
        hash['success'].should == true
        hash['response']['url'].should == link[:url]
      end
    end

    describe 'GET /validate' do
      it 'makes sure a valid key is valid' do
        custom = Faker.numerify('######')

        get '/validate', { :custom => custom }

        hash = last_hash
        hash['success'].should == true
        hash['response'].should == custom
      end

      it 'makes sure an invalid key is invalid' do
        custom = Faker.numerify('####')

        get '/validate', { :custom => custom }

        hash = last_hash
        hash['success'].should == false
        hash['response'].should == custom
      end
    end

    describe 'GET /qr' do
      it 'gets a qr code' do
        key = Faker.numerify('#####')

        get '/qr', { :key => key }

        hash = last_hash
        hash['success'].should == true
      end
    end

    describe 'GET /stats' do
      it 'returns stats about a given key' do
        url = Faker::Internet.http_url
        key = Faker.numerify('#####')
        link = link_hash gen_link(key, url)

        get '/stats', { :key => key }

        hash = last_hash
        hash['success'].should == true
        hash['response']['key'].should == key
        hash['response']['hits'].should_not == nil
      end
    end
  end
end
