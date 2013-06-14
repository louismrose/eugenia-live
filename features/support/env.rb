require 'capybara'
require 'capybara/cucumber'
require 'capybara/dsl'
require 'rspec'
require 'capybara/poltergeist'

Capybara.app_host = 'http://localhost:9294'
Capybara.default_driver = :poltergeist

# Hack to destroy all local storage before running tests
# Ideally, I'd like to configure Poltergeist to tell Phantom.js to use
# a different location for local storage and then delete that location
# before each test run. However, passing options relating to local storage
# (quota and path) to Phantom.js via Poltergeist seems to broken right now.
`rm -rf ~/Library/Application\\ Support/Ofi\\ Labs/PhantomJS/http_localhost_9294.localstorage`