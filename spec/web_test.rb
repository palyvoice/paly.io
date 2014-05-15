require 'rack/test'
require 'minitest/autorun'
require 'ffaker'
require 'spec_helper'
require './app'

describe PalyIO::Web do
  include Rack::Test::Methods

  def app
    PalyIO::Web
  end

  before(:all) do
    @@browser = Selenium::WebDriver.for(:chrome)
  end

  before(:each) do
    @@browser.get(ENV['PALYIO_HOSTNAME'])
  end
end
