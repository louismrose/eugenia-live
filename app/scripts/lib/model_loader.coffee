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
        model.extend(Spine.Model.Local) unless model is PaletteSpecification
        model.fetch()