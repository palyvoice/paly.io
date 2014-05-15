require 'selenium-webdriver'

browser = Selenium::WebDriver.for(:chrome)

browser.get(ENV['PALYIO_HOSTNAME'])

urlfield = browser.find_element(:id, 'url')
urlfield.send_keys('palyvoice.com')

submitbutton = browser.find_element(:id, 'submit')
submitbutton.click

browser.quit

