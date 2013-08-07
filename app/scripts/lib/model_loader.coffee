define [
  'spine'
], (Spine) ->

  class ModelLoader
    @setup: ->
      modelNames = []
      #   "palette_specification"
      #   "palette"
      #   "link_shape"
      #   "node_shape"
      #   "drawing"
      #   "node"
      #   "link"
      # ]
    
      for modelName in modelNames
        model = require("models/#{model_name}")
        model.extend(Spine.Model.Local) unless modelName is "palette_specification"
        model.fetch()