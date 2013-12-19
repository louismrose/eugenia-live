define [
  'paper'
  'viewmodels/drawings/stencils/labelled_stencil'
  'viewmodels/drawings/paper/rectangle'
  'models/property_set'
], (paper, LabelledStencil, Rectangle, PropertySet) ->

  describe 'LabelledStencil', ->
    describe 'it has sensible defaults', ->      
      it 'draws no label by default', ->
        shape = createShape()
        result = createLabel(shape)
        expect(result).toEqual(shape)
    
    describe 'can use stencil specification', ->  
      describe 'when placement is none', ->
        it 'draws no label', ->
          shape = createShape()
          result = createLabel(shape, {placement: 'none'})
          expect(result).toEqual(shape)

      describe 'when placement is internal', ->
        beforeEach ->
          @shape = createShape()
          @label = createLabel(@shape, {placement: 'internal', text: 'foo'})
          
        it 'creates a LabelledPath', ->
          expect(@label.constructor.name).toBe('LabelledPath')
        
        it 'displays the correct content for the label', ->
          expect(@label.content()).toEqual('foo')
        
        it 'positions the label at the centre of the shape', ->
          expect(@label.position().x).toEqual(@shape.position().x)
          expect(@label.position().y).toEqual(@shape.position().y)

      describe 'when placement is external', ->
        beforeEach ->
          @shape = createShape()
          @label = createLabel(@shape, {placement: 'external'})
        
        it 'positions the label below the bottom centre of the shape', ->
          expect(@label.position().x).toEqual(@shape.bottomCenter().x)
          expect(@label.position().y).toEqual(@shape.bottomCenter().y + 20)         
          
      describe 'when text contains property references', ->
        it 'has content containing property values', ->
          result = createLabel(createShape(), {placement: 'internal', text: '${surname}, ${forename}' }, { forename: 'John', surname: 'Doe' })
          expect(result.content()).toEqual('Doe, John')

      describe 'when length is defined', ->
        it 'trims content longer than the length', ->
          result = createLabel(createShape(), {placement: 'internal', length: 7, text: '1234567890' })
          expect(result.content()).toEqual('1234...')

        it 'does not trims content of precisely the right length', ->
          result = createLabel(createShape(), {placement: 'internal', length: 7, text: '1234567' })
          expect(result.content()).toEqual('1234567')
        
      describe 'when color is defined', ->
        it 'displays the label in the specified colour', ->
          result = createLabel(createShape(), {placement: 'internal', color: 'red' })
          expect(result.fillColor().toCSS()).toEqual("rgb(255,0,0)")

    createShape = ->
      new Rectangle(10, 20)
      
    createLabel = (shape, options, properties = {}) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = new LabelledStencil(options, new FakeStencil(shape))
      stencil.draw(new FakeNode(properties))
      
    class FakeStencil
      constructor: (@shape) ->
      draw: (node) ->
        @shape
    
    class FakeNode
      constructor: (properties) ->
        @properties = new PropertySet(new FakeShape(properties), properties)

    class FakeShape
      constructor: (@properties) ->
      defaultPropertyValues: ->
        @properties
