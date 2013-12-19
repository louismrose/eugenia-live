define [
  'paper'
  'viewmodels/drawings/stencils/labelled_stencil'
  'viewmodels/drawings/paper/rectangle'
  'models/property_set'
], (paper, LabelledStencil, Rectangle, PropertySet) ->

  describe 'LabelledStencil', ->
    beforeEach ->
      @shape = new Rectangle(10, 20)
      
      @createLabelledPath = (options, properties = {}) ->  
        paper = new paper.PaperScope()
        paper.project = new paper.Project()
        stencil = new LabelledStencil(options, new FakeStencil(@shape))
        stencil.draw(new FakeNode(properties))
    
    describe 'it has sensible defaults', ->      
      it 'draws no label by default', ->
        expect(@createLabelledPath()).toEqual(@shape)
    
    describe 'can use stencil specification', ->  
      describe 'placement', ->
        it 'when none, it draws no label', ->
          expect(@createLabelledPath(placement: 'none')).toEqual(@shape)

        it 'when internal, it draws a LabelledPath with the right properties', ->
          path = @createLabelledPath(placement: 'internal')
          expect(path.constructor.name).toBe('LabelledPath')

        it 'when external, it draws a LabelledPath with the right properties', ->
          path = @createLabelledPath(placement: 'external')
          expect(path.constructor.name).toBe('LabelledPath')
                  
      describe 'when text contains property references', ->
        it 'has a label with content containing property values', ->
          path = @createLabelledPath({placement: 'internal', text: '${surname}, ${forename}' }, { forename: 'John', surname: 'Doe' })
          expect(path.label.text()).toEqual('Doe, John')
      
      it 'passes options to labelled path', ->
        properties = { placement: 'external', color: 'green', text: 'foo', length: 255 }
        path = @createLabelledPath(properties)
        expect(path._properties).toEqual(properties)
      
      
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
