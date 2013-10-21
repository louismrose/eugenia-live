define [
  'paper'
  'viewmodels/drawings/rounded_rectangle'
], (paper, RoundedRectangle) ->

  describe 'RoundedRectangle', ->  
    describe 'has sensible defaults', ->
      beforeEach ->
        @alwaysDefaultsPropertySet =
          resolve: (expression, defaultValue) =>
            defaultValue
      
      it 'defaults width to 100', ->
        result = createElement(@alwaysDefaultsPropertySet)
        expect(result.bounds.width).toBe(100)   
      
      it 'defaults height to 100', ->
        result = createElement(@alwaysDefaultsPropertySet)
        expect(result.bounds.height).toBe(100)
      
      it 'inherits default fillColor from element', ->
        expect(new RoundedRectangle().defaults()["fillColor"]).toBe("white")
        
    describe 'can use options', ->
      beforeEach ->
        @alwaysResolvesPropertySet =
          resolve: (expression, defaultValue) =>
            expression
      
      it 'sets width according to size.width option', ->
        result = createElement(@alwaysResolvesPropertySet, { size: { width: 50 } } )
        expect(result.bounds.width).toBe(50)
    
      it 'sets height according to size.height option', ->
        result = createElement(@alwaysResolvesPropertySet, { size: { height: 75 } } )
        expect(result.bounds.height).toBe(75)
        
    
    createElement = (propertySet, options = {}) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      element = new RoundedRectangle(options)
      node = new FakeNode(propertySet)
      result = element.draw(node)      

    class FakeNode
      constructor: (@properties) ->
