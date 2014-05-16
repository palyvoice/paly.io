require './app'
require 'spec_helper'

describe PalyIO::Web do
  before(:all) do
    Capybara.app = PalyIO::Web
    Capybara.current_driver = :chrome
  end

  after(:all) do
    Capybara.use_default_driver
  end

  before(:each) do
    visit '/'
  end

  describe 'home page' do
    it 'is not 502ing' do
      page.should have_content "Paste your long URL here"
      page.should have_content "Maxwell Bernstein and Christopher Hinstorff"
    end

    it 'should have a submittable form' do
      within '#urlform' do
        fill_in 'url', :with => Faker::Internet.http_url
        fill_in 'customurl', :with => Faker.numerify('######')
      end
      # click_button
    end
  end
end
