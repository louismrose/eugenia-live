define [
  'models/node_shape'
  'models/node'
  'viewmodels/drawings/paths/ellipse'
  'viewmodels/drawings/canvas_element_factory'
  'viewmodels/drawings/node_canvas_element'
  'models/commands/commander'
  'models/commands/change_property'
], (NodeShape, Node, Ellipse, CanvasElementFactory, NodeCanvasElement, Commander, ChangeProperty) ->

  describe 'property values can affect appearance', ->
    it 'a property value that affects appearance is respected when the path is created', ->
      shape = new NodeShape(
        name: "Cell"
        properties: [ "rate" ]
        elements: [
          figure: "ellipse"
          size: { width: "${rate}", height: "${rate}" }
        ]
      )
      shape.save()
      
      node = new Node({ shape: shape.id })
      node.properties.set("rate", 50)
      
      canvas = null
      factory = new CanvasElementFactory(canvas)
      canvasElement = factory.createCanvasElementFor(node)
      path = canvasElement._path
      
      expect(path.width()).toBe(50)
      expect(path.height()).toBe(50)


