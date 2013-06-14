Installation
============

1. Install NPM (by [installing Node.js](http://nodejs.org/)).
2. Clone this Git repository.
3. Install hem: `sudo npm install -g hem`
4. Launch the development server: `hem server` or `./server.sh`


Development Dependencies
========================

To be able to run the acceptance tests:

1. `brew update && brew install phantomjs`
2. Install Ruby via RVM
3. Install bundler: `gem install bundler`
4. Install Ruby dependencies: `bundle install`

Run the acceptance tests with `bundle exec cucumber`