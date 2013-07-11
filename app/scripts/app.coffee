define [
  'spine'
  'lib/model_loader'
  'controllers/drawings'
  'controllers/palettes'
  'controllers/simulations'
  'spine.route'
  'bootstrap'
], (Spine, ModelLoader, Drawings, Palettes, Simulations) ->

  class App extends Spine.Stack
    controllers:
      drawings: Drawings
      palettes: Palettes
      simulations: Simulations
      
    routes:
      '/drawings/:d_id/palette' : 'palettes'
      '/drawings'               : 'drawings'
  
    default: 'drawings'
  
    constructor: ->
      super
      ModelLoader.setup()
      Spine.Route.setup()
      @navigate('/drawings')