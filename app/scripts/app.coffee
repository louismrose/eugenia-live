define [
  'spine'
  'lib/model_loader'
  'controllers/drawings'
  'spine.route',
  'bootstrap'
], (Spine, ModelLoader, Drawings) ->

  class App extends Spine.Stack
    controllers:
      drawings: Drawings
      
    routes:
      '/drawings'               : 'drawings'
  
    default: 'drawings'
  
    constructor: ->
      super
      ModelLoader.setup()
      Spine.Route.setup()
      @navigate('/drawings')
      
# define [
#   'spine'
#   'lib/model_loader'
#   'controllers/palettes'
#   'controllers/drawings'
# ], (Spine, ModelLoader, Palettes, Drawings) ->
# 
#   class App extends Spine.Stack
#     controllers:
#       palettes: Palettes
#       drawings: Drawings
#       
#     routes:
#       '/drawings/:d_id/palette' : 'palettes'
#       '/drawings'               : 'drawings'
#   
#     default: 'drawings'
#   
#     constructor: ->
#       super
#       ModelLoader.setup()
#       Spine.Route.setup()
#       @navigate('/drawings')
#       
