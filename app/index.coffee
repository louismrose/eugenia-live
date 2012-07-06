require('lib/setup')

Spine = require('spine')
Drawings = require('controllers/drawings')

class App extends Spine.Controller
  constructor: ->
    super
    
    @drawings = new Drawings(el: @el)
    
    Spine.Route.add '/drawings/:id', (params) =>
      @drawings.show.active(params)

    Spine.Route.add '/drawings', (params) =>
      @drawings.index.active(params)
      
    Spine.Route.add '/palettes/:p_id/:type/:id', (params) =>
      @log("To be implemented")
    
    # Redirect any other route  
    Spine.Route.add '*glob', (params) =>
      @navigate('/drawings')
    
    Spine.Route.setup()
      
module.exports = App
    