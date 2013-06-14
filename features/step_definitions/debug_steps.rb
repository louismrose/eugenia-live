require 'launchy'

Then(/^show me the page$/) do
  save_screenshot('debug.png', full: true)
  Launchy.open('./debug.png')
end
