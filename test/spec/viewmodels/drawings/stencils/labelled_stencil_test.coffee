define [
  'paper'
  'viewmodels/drawings/stencils/labelled_stencil'
  'viewmodels/drawings/paths/rectangle'
  'models/property_set'
], (paper, LabelledStencil, Rectangle, PropertySet) ->

  describe 'LabelledStencil', ->
    describe 'it has sensible defaults', ->     
      beforeEach ->
        @defaults = createStencil().defaultSpecification()
      
      it 'defaults placement to none', ->
        expect(@defaults.get("placement")).toBe("none")
      
      it 'defaults color to black', ->
        expect(@defaults.get("color")).toBe("black")
      
      it 'defaults text to the empty string', ->
        expect(@defaults.get("text")).toBe('')
      
      it 'defaults length to 30', ->
        expect(@defaults.get("length")).toBe(30)


    describe 'translates properties for LabelledPath', ->
      it 'sets placement according to placement option', ->
        expect(getPropertiesFor(placement: 'external').placement).toBe('external')
    
      it 'sets color according to color option', ->
        expect(getPropertiesFor(color: 'red').color).toBe('red')

      it 'sets text according to text option', ->
        expect(getPropertiesFor(text: 'foo').text).toBe('foo')

      it 'sets length according to length option', ->
        expect(getPropertiesFor(length: 12).length).toBe(12)
    
        
    describe 'draw', ->
      beforeEach ->
        # Create Stencil to be decorated by the LabelledStencil
        @labelledPath = new Rectangle(10, 20)
        decorated = jasmine.createSpyObj('stencil', ['draw'])
        decorated.draw.andReturn(@labelledPath)
        
        @draw = (properties) =>
          stencil = createStencil(properties, decorated)
          stencil.draw(new FakeNode)
      
      it 'returns a LabelledPath when placement is none', ->
        labelledPath = @draw(placement: 'none')
        expect(labelledPath.constructor.name).toBe('LabelledPath')
        expect(labelledPath.path).toBe(@labelledPath)
      
      it 'returns a LabelledPath when placement is internal', ->
        labelledPath = @draw(placement: 'internal')
        expect(labelledPath.constructor.name).toBe('LabelledPath')
        expect(labelledPath.path).toBe(@labelledPath)
      
      it 'returns a LabelledPath when placement is external', ->
        labelledPath = @draw(placement: 'external')
        expect(labelledPath.constructor.name).toBe('LabelledPath')
        expect(labelledPath.path).toBe(@labelledPath)
      
      it 'passes properties to LabelledPath', ->
        properties = { placement: 'external', color: 'green', text: 'foo', length: 255 }
        path = @draw(properties)
        expect(path._properties).toEqual(properties)
        
    
    describe 'redraw', ->
      beforeEach ->
        # Create Stencil to be decorated by the LabelledStencil
        @node = new FakeNode
        @labelledPath = new Rectangle(10, 20)
        @decorated = jasmine.createSpyObj('stencil', ['draw', 'redraw'])
        @decorated.draw.andReturn(@labelledPath)
        
        @redraw = (properties = {}) =>
          stencil = createStencil(properties, @decorated)
          path = stencil.draw(@node)
          stencil.redraw(@node, path)
          path
      
      it 'redraws the decorated stencil with the correct path', ->
        @redraw()
        expect(@decorated.redraw).toHaveBeenCalledWith(@node, @labelledPath)
      
      it 'redraws the label by passing properties', ->
        properties = { placement: 'external', color: 'green', text: 'foo', length: 255 }
        path = @redraw(properties)
        expect(path._properties).toEqual(properties)

    
    createStencil = (specification = {}, labelledStencil) ->
      new LabelledStencil(specification, labelledStencil)
    
    getPropertiesFor = (stencilSpec = {}) ->
      createStencil(stencilSpec)._properties(new FakeNode)
    
    class FakeNode
      properties:
        resolve: (expression, defaultValue) =>
          expression