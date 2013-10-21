define [
  'paper'
  'viewmodels/drawings/element_factory'
  'viewmodels/drawings/rectangle'
  'viewmodels/drawings/rounded_rectangle'
  'viewmodels/drawings/ellipse'
  'viewmodels/drawings/polygon'
], (paper, ElementFactory, Rectangle, RoundedRectangle, Ellipse, Polygon) ->

  describe 'ElementFactory', ->  
    it 'creates a rectangle', ->
      result = elementFor(figure: "rectangle")
      expect(result instanceof Rectangle).toBeTruthy()
    
    it 'creates a rounded rectangle', ->
      result = elementFor(figure: "rounded")
      expect(result instanceof RoundedRectangle).toBeTruthy()

    it 'creates an ellipse', ->
      result = elementFor(figure: "ellipse")
      expect(result instanceof Ellipse).toBeTruthy()

    it 'creates a polygon', ->
      result = elementFor(figure: "polygon")
      expect(result instanceof Polygon).toBeTruthy()
    
    it 'throws an error for unknown type of element', ->
      expect(=> elementFor(figure: "cube")).toThrow()
    
    elementFor = (element) ->  
      factory = new ElementFactory()
      factory.elementFor(element)
