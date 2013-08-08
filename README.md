Setup
=====

Tools
-----

1. Install NPM (by [installing Node.js](http://nodejs.org/)).
2. Install Yeoman, Grunt and Bower: `(sudo) npm install -g yo grunt-cli bower`
3. Install Phantom.js (used for tests): `brew update && brew install phantomjs`
4. Install Ruby via RVM (used for converting SCSS into CSS) and bundler `gem install bundler`

Dependencies
------------

1. Clone this Git repository.
2. `cd eugenia-live`
3. Install client-side dependencies (e.g. Spine, Paper): `bower install --save`
4. Install development dependencies: `npm install` (Node) and `bundle install` (Ruby)


Developing
==========
Grunt, the Javascript build library, is responsible for compilation of our Coffeescript, launching a development server, running the tests, etc.

Running a development server
----------------------------

1. Run `grunt server`
2. Edit the source files (in `app/scripts`)
3. When you save your changes, the server will automatically reload the app

Running the unit tests
----------------------

1. Edit the unit tests (in `test/spec`)
2. Run `grunt test`
3. The results will be reported on the console.

Running the acceptance tests
----------------------------

1. Edit the acceptance tests (in `features`)
2. Run `bundle exec cucumber`
3. The results will be reported on the console.

Adding a new client-side dependency
-----------------------------------

1. Identify the component in [bower's repository](http://sindresorhus.com/bower-components/)
2. Run `bower install <component> --save`
3. Edit `app/scripts/main.coffee` to load the new component. You will need to add a path, and possible a shim. See the [require.js](http://requirejs.org/docs/api.html#config) documentation for more information.
4. In any other .coffee file, require your new component using the normal require.js syntax: 

        define [
          'component'
        ], (Component) ->
          // use your component, e.g. new Component()

Adding a new development dependency
-----------------------------------

1. Identify the package in [NPM's repository](https://npmjs.org). Typically this will be a grunt extension, such as `grunt-symlink`
2. Run `npm install <package> --save-dev`
3. Add a task to the `Gruntfile.js` that uses your new package:

        symlink: {
            bower: {
                dest: '.tmp/bower_components',
                relativeSrc: '../app/bower_components',
                options: {type: 'dir'}
            },
            jasmine: {
                dest: '.tmp/.grunt',
                relativeSrc: '../.grunt',
                options: {type: 'dir'}
            }
        }


Deploying
=========

1. Run `grunt build`
2. Contact Louis! (Documentation to follow)