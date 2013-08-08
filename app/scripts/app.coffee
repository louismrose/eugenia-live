define [
  'spine'
  'lib/model_loader'
  'controllers/drawings'
  'controllers/palettes'
  'spine.route'
  'bootstrap'
], (Spine, ModelLoader, Drawings, Palettes) ->

  class App extends Spine.Stack
    controllers:
      drawings: Drawings
      palettes: Palettes
      
    routes:
      '/drawings/:d_id/palette' : 'palettes'
      '/drawings'               : 'drawings'
  
    default: 'drawings'
  
    constructor: ->
      super
      ModelLoader.setup()
      Spine.Route.setup()
      @navigate('/drawings')