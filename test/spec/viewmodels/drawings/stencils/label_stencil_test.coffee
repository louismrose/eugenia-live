define [
  'paper'
  'viewmodels/drawings/stencils/label_stencil'
  'models/property_set'
], (paper, LabelStencil, PropertySet) ->

  # TODO
  # -- might want to make use of paper.Item's style property that allows multiple style elements to be set in one go

  describe 'LabelStencil', ->
    describe 'it has sensible defaults', ->      
      it 'draws no label by default', ->
        shape = createShape()
        result = createLabel(shape)
        expect(result.children).toEqual([shape])
    
    describe 'can use stencil specification', ->  
      describe 'when placement is none', ->
        it 'draws no label', ->
          shape = createShape()
          result = createLabel(shape, {placement: 'none'})
          expect(result.children).toEqual([shape])      

      describe 'when placement is internal', ->
        beforeEach ->
          @shape = createShape()
          @result = createLabel(@shape, {placement: 'internal', text: 'foo'})
          @label = @result.lastChild
          
        it 'adds a label to the group', ->
          expect(@result.children).toEqual([@shape, @label])
        
        it 'uses PointText for the label', ->
          expect(@label instanceof paper.PointText).toBeTruthy()
        
        it 'displays the correct content for the label', ->
          expect(@label.content).toEqual('foo')
        
        it 'positions the label at the centre of the shape', ->
          expect(@label.position.x).toEqual(@shape.position.x)
          expect(@label.position.y).toEqual(@shape.position.y)

      describe 'when placement is external', ->
        beforeEach ->
          @shape = createShape()
          @result = createLabel(@shape, {placement: 'external'})
          @label = @result.lastChild
        
        it 'positions the label below the bottom centre of the shape', ->
          expect(@label.position.x).toEqual(@shape.bounds.bottomCenter.x)
          expect(@label.position.y).toEqual(@shape.bounds.bottomCenter.y + 20)         
          
      describe 'when text contains property references', ->
        it 'has content containing property values', ->
          result = createLabel(createShape(), {placement: 'internal', text: '${surname}, ${forename}' }, { forename: 'John', surname: 'Doe' })
          expect(result.lastChild.content).toEqual('Doe, John')

      describe 'when length is defined', ->
        it 'trims content longer than the length', ->
          result = createLabel(createShape(), {placement: 'internal', length: 7, text: '1234567890' })
          expect(result.lastChild.content).toEqual('1234...')

        it 'does not trims content of precisely the right length', ->
          result = createLabel(createShape(), {placement: 'internal', length: 7, text: '1234567' })
          expect(result.lastChild.content).toEqual('1234567')
        
      describe 'when color is defined', ->
        it 'displays the label in the specified colour', ->
          result = createLabel(createShape(), {placement: 'internal', color: 'red' })
          expect(result.lastChild.fillColor.toCSS()).toEqual("rgb(255,0,0)")

      
    createShape = ->
      new paper.Path.Rectangle(new paper.Point(0,0), new paper.Size(10, 20))
      
    createLabel = (shape, options, properties = {}) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      stencil = new LabelStencil(options)
      stencil.draw(new FakeNode(properties), shape)
      
    class FakeNode
      constructor: (properties) ->
        @properties = new PropertySet(new FakeShape(properties), properties)

    class FakeShape
      constructor: (@properties) ->
      defaultPropertyValues: ->
        @properties
