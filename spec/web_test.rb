require './app'
require 'spec_helper'

describe PalyIO::Web do
  before(:all) do
    # ensure both API and Web are running, so that the JS doesn't die
    Capybara.app, _ = Rack::Builder.parse_file(File.expand_path('../../config.ru', __FILE__))
    Capybara.current_driver = :chrome
  end

  after(:all) do
    Capybara.use_default_driver
  end

  before(:each) do
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
      expect(page).to have_content 'Valid custom URL.'
    end
  end
end
