define [
  'paper'
  'viewmodels/drawings/polygon'
], (paper, Polygon) ->

  describe 'Polygon', ->  
    describe 'has sensible defaults', ->
      beforeEach ->
        @alwaysDefaultsPropertySet =
          resolve: (expression, defaultValue) =>
            defaultValue
      
      it 'defaults sides to 3', ->
        result = createElement(@alwaysDefaultsPropertySet)
        expect(result.segments.length).toBe(3)   
      
      it 'defaults radius to 50', ->
        expect(new Polygon().defaults()["radius"]).toBe(50)
      
      it 'inherits default fillColor from element', ->
        expect(new Polygon().defaults()["fillColor"]).toBe("white")
        
    describe 'can use options', ->
      beforeEach ->
        @alwaysResolvesPropertySet =
          resolve: (expression, defaultValue) =>
            expression
      
      it 'sets sides according to sides option', ->
        result = createElement(@alwaysResolvesPropertySet, { sides: 12 } )
        expect(result.segments.length).toBe(12)
    
      it 'sets radius according to radius option', ->
        polygon = new Polygon(radius: 75)
        expect(polygon._radius(new FakeNode(@alwaysResolvesPropertySet))).toBe(75)
            
    createElement = (propertySet, options = {}) ->
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      element = new Polygon(options)
      node = new FakeNode(propertySet)
      result = element.draw(node)

    class FakeNode
      constructor: (@properties) ->
