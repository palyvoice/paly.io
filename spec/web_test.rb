require 'spec_helper'
require 'pry'

describe PalyIO::Web do
  include Rack::Test::Methods

  def app
    PalyIO::Web
  end

  before :all do
    Capybara.app_host = ENV['PALYIO_HOSTNAME']
    Capybara.run_server = false
    Capybara.current_driver = :chrome
  end

  after :all  do
    Capybara.use_default_driver
  end

  before :each do
    visit '/'
  end

  describe 'home page', :js => true, :driver => :chrome do
    it 'is not 502ing' do
      page.should have_content 'Paste your long URL here'
      page.should have_content 'Maxwell Bernstein and Christopher Hinstorff'
    end

    it 'should have a submittable form' do
      within '#urlform' do
        fill_in 'url', :with => Faker::Internet.http_url
        fill_in 'customurl', :with => Faker.numerify('######')
      end
      find_button('submit').click
      expect(page).to have_content 'Your shortened URL is'
    end

    it 'disallows custom urls under 5 characters' do
      within '#urlform' do
        fill_in 'url', :with => Faker::Internet.http_url
        fill_in 'customurl', :with => Faker.numerify('##')
      end
      find_button('submit').click
      expect(page).to have_content 'Error'
    end

    it 'successfully generates a random url' do
      within '#urlform' do
        fill_in 'url', :with => Faker::Internet.http_url
      end
      find_button('submit').click
      expect(page).to have_content 'Your shortened URL is'
    end

    it 'displays a message after you stop typing a custom url' do
      within '#urlform' do
        fill_in 'customurl', :with => Faker.numerify('#######')
      end
      expect(page).to have_content 'URL is valid.'
      expect(page).to have_selector('.message-box.valid', :visible => true)

      within '#urlform' do
        fill_in 'customurl', :with => ''
      end
      expect(page).to have_selector('.message-box.valid', :visible => false)
    end

    it 'redirects properly' do
      url = Faker::Internet.http_url
      custom = Faker.numerify '######'
      l = Link.create :shortkey => custom, :url => url

      get "/#{custom}"

      last_response.should be_redirect
      follow_redirect!

      # Need to remove trailing slash because apparently Chrome adds it
      last_request.url.chomp('/').should == url

      # If the above is too hacky, check the headers for redirect. Could also
      # check the HTTP code (expected 301 moved temporarily)
      # last_response.header['Location'].should == url
    end
  end
end
