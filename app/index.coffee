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
    '/drawings' : 'drawings'
    '/palettes' : 'palettes'
  
  default: 'drawings'
  
  constructor: ->
    super
    Spine.Route.setup()
    @navigate('/drawings')
      
module.exports = App  
