define [
  'paper'
  'viewmodels/drawings/label'
  'models/property_set'
], (paper, Label, PropertySet) ->

  # TODO
  # -- when I extract options, might be able to re-use for the contentFor part of label (and might want to support label colour etc to be bound against options, just like in stencils)
  # -- might want to make use of paper.Item's style property that allows multiple style elements to be set in one go

  describe 'Label', ->
    describe 'placement is none', ->
      it 'just wraps shape into a group', ->
        shape = new paper.Path.Rectangle(new paper.Point(0,0), new paper.Size(10, 20))
        result = createLabel(shape, {placement: 'none'})
        expect(result.children).toEqual([shape])
      
    describe 'placement is internal', ->
      it 'adds a label to the group', ->
        shape = new paper.Path.Rectangle(new paper.Point(0,0), new paper.Size(10, 20))
        result = createLabel(shape, {placement: 'internal', text: 'foo'})
        label = result.lastChild

        expect(result.firstChild).toEqual(shape)
        expect(label instanceof paper.PointText).toBeTruthy()
        expect(label.content).toEqual('foo')
        expect(label.position.x).toEqual(shape.position.add([0, 5]).x)
        # expect(label.position.y).toEqual(shape.position.add([0, 5]).y)

    describe 'text is a property', ->
      it 'displays properties according to pattern', ->
        shape = new paper.Path.Rectangle(new paper.Point(0,0), new paper.Size(10, 20))
        node = new FakeNode({ name: 'John' })
        result = createLabel2(shape, {placement: 'internal', text: '${name}' }, node)
        label = result.lastChild

        expect(node.properties.get('name')).toEqual('John')
        expect(label.content).toEqual('John')

    describe 'text combines literal text with properties', ->
      it 'displays properties according to pattern', ->
        shape = new paper.Path.Rectangle(new paper.Point(0,0), new paper.Size(10, 20))
        result = createLabel(shape, {placement: 'internal', text: '${surname}, ${forename}' }, { forename: 'John', surname: 'Doe' })
        label = result.lastChild

        expect(label.content).toEqual('Doe, John')
      

      
    createLabel = (shape, options, properties = {}) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      label = new Label(options)
      label.draw(new FakeNode(properties), shape)
      
    createLabel2 = (shape, options, node = new FakeNode({})) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      label = new Label(options)
      result = label.draw(node, shape)
      result
      
    class FakeNode
      constructor: (properties) ->
        @properties = new PropertySet(new FakeShape(properties), properties)

    class FakeShape
      constructor: (@properties) ->
      defaultPropertyValues: ->
        @properties
