require './app'
require 'spec_helper'

describe PalyIO::Web do
  before(:all) do
    Capybara.app_host = ENV['PALYIO_HOSTNAME']
    Capybara.run_server = false
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
      expect(page).to have_content 'URL is valid.'

      within '#urlform' do
        fill_in 'customurl', :with => ''
      end

      # somehow get the new JS to clear the message box in the tests :(
      page.find('.message-box.valid').visible?.should == false
      save_and_open_page
    end
  end
end
