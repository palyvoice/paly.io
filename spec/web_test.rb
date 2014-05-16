require './app'
require 'spec_helper'

set :environment, :test

describe PalyIO::Web do
  include Capybara::DSL

  Capybara.app = PalyIO::Web

  describe 'home page' do
    it 'submits a form to shorten a url' do
      visit '/'
      page.should have_content "Paste your long URL here"
      page.should have_content "Maxwell Bernstein and Christopher Hinstorff"
    end
  end
end
