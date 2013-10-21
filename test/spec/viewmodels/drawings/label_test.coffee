define [
  'paper'
  'viewmodels/drawings/label'
], (paper, Label) ->

  # TODO
  # -- when I extract options, might be able to re-use for the contentFor part of label (and might want to support label colour etc to be bound against options, just like in stencils)
  # -- might want to make use of paper.Item's style property that allows multiple style elements to be set in one go

  describe 'Label', ->
    describe 'placement is none', ->
      it 'just wraps shape into a group', ->
        shape = new paper.Path.Rectangle(new paper.Point(0,0), new paper.Size(10, 20))
        result = createLabel({placement: 'none'}, {}, shape)
        expect(result.children).toEqual([shape])
      
    describe 'placement is internal', ->
      it 'does stuff', ->
        shape = new paper.Path.Rectangle(new paper.Point(0,0), new paper.Size(10, 20))
        result = createLabel({placement: 'internal', for: ['name']}, { name: 'John' }, shape)
        label = result.lastChild

        expect(result.firstChild).toEqual(shape)
        expect(label instanceof paper.PointText).toBeTruthy()
        expect(label.position.x).toEqual(shape.position.add([0, 5]).x)
        # expect(label.position.y).toEqual(shape.position.add([0, 5]).y)

      
    createLabel = (options, properties, shape) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      label = new Label(options)
      result = label.draw(new FakeNode(properties), shape)   
      
    class FakeNode
      constructor: (properties) ->
        @properties =
          bind: (event, handler) =>
          get: (property) =>
            properties[property]