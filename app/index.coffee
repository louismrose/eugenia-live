require('lib/setup')

Spine = require('spine')
Drawings = require('controllers/drawings')
Palettes = require('controllers/palettes')

class App extends Spine.Stack
  constructor: ->
    super
    
    @drawings = new Drawings(el: @el)
    @palettes = new Palettes(el: @el)
    
    Spine.Route.add '/drawings/:id', (params) =>
      @drawings.show.active(params)

    Spine.Route.add '/drawings', (params) =>
      @drawings.index.active(params)
    
    Spine.Route.add '/drawings/:d_id/:type/:id', (params) =>
      @drawings.show.deactivate()
      if (params.id is 'new')
        @palettes.create.active(params)
      else
        @palettes.edit.active(params)
    
    # Redirect any other route  
    Spine.Route.add '*glob', (params) =>
      @navigate('/drawings')
    
    Spine.Route.setup()
      
module.exports = App  