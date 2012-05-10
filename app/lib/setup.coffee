require('json2ify')
require('es5-shimify')
require('jqueryify')
require('lib/bootstrap.min')
require('lib/bootstrap-button')
require('lib/bootstrap-collapse')
require('lib/bootstrap-dropdown')

# Using Spine from Github due to a bug in LocalStorage in 1.0.6
# To use a stabled version of Spine:
#   1) Uncomment the following
#   2) Update slug.json:
#    a) Remove Spine as a Javascript dependency ("libs")
#    b) Add Spine as a NPM dependency ("dependencies").
#       See a newly generated Spine.app application for an example of this.
#   3) Install the latest version of Spine
#      (Presumably by running something like 'npm install .')
#   4) Reinstate the Spine = require("spine") statements throughout the app
# 
# require('spine')
# require('spine/lib/local')
# require('spine/lib/ajax')
# require('spine/lib/manager')
# require('spine/lib/route')
# require('spine/lib/tmpl')