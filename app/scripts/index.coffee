require('lib/setup')
require('lib/fetch_models')

Spine = require('spine')
Drawings = require('controllers/drawings')
Palettes = require('controllers/palettes')

class App extends Spine.Stack
  controllers:
    palettes: Palettes
    drawings: Drawings
      
  routes:
    '/drawings/:d_id/palette' : 'palettes'
    '/drawings'               : 'drawings'
  
  default: 'drawings'
  
  constructor: ->
    super
    Spine.Route.setup()
    @navigate('/drawings')
      
module.exports = App  
