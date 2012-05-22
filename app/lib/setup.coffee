# Using Spine from Github due to a bug in LocalStorage in 1.0.6
# To use a stable version of Spine:
#   1) Uncomment the jqueryify and spine require statements below
#   2) Update slug.json:
#    a) Remove Spine and JQuery as a Javascript dependency ("libs")
#    b) Add Spine and JQueryify as NPM dependencies ("dependencies").
#       See a newly generated Spine.app application for an example of this.
#   3) Install the latest version of Spine
#      (Presumably by running something like 'npm install .')
#   4) Reinstate the Spine = require("spine") statements throughout the app
#   5) Remove the Spine and JQuery sources from the lib directory.
#   6) In HTML files, load JQuery via JQuerify rather than using $:
#        Use this: var jQuery  = require("jqueryify");
#        Rather than this: var jQuery  = $;

require('json2ify')
require('es5-shimify')
# require('jqueryify')
require('lib/bootstrap.min')
require('lib/bootstrap-button')
require('lib/bootstrap-collapse')
require('lib/bootstrap-dropdown')

# require('spine')
# require('spine/lib/local')
# require('spine/lib/ajax')
# require('spine/lib/manager')
# require('spine/lib/route')
# require('spine/lib/tmpl')