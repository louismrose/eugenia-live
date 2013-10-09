define [
  'spine'
  'models/palette_specification'
  'models/palette'
  'models/link_shape'
  'models/node_shape'
  'models/drawing'
  'models/node'
  'models/link'
  'spine.model.local'
  'spine.model.realtime'
], (Spine, PaletteSpecification, Palette, LinkShape, NodeShape, Drawing, Node, Link) ->

  class ModelLoader
    @setup: ->
      models = [
        PaletteSpecification
        Palette
        LinkShape
        NodeShape
        Drawing
        Node
        Link
      ]
      
      for model in models
        if model is PaletteSpecification
          model.extend(Spine.Model.Local)
          model.fetch()
        else
          model.extend(Spine.Model.Realtime)