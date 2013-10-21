define [
  'paper'
  'viewmodels/drawings/stencils/composite_stencil'
], (paper, CompositeStencil) ->

  describe 'CompositeStencil', ->  
    it 'draws a group', ->
      result = createCompositeStencil()
      expect(result instanceof paper.Group).toBeTruthy()
    
    it 'calls draw on for every stencil in array', ->
      rectangle = new FakeRectangleStencil()
      ellipse = new FakeEllipseStencil()
      result = createCompositeStencil([rectangle, ellipse])
      
      expect(rectangle.drawn).toBeTruthy()
      expect(ellipse.drawn).toBeTruthy()
    
    it 'creates a child for every stencil in array', ->
      result = createCompositeStencil([new FakeRectangleStencil(), new FakeEllipseStencil()])
      expect(result.children.length).toBe(2)
    
    createCompositeStencil = (stencils) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      composite = new CompositeStencil(stencils)
      result = composite.draw({})

    class FakeRectangleStencil
      drawn: false
      draw: (node) =>
        @drawn = true
        new paper.Path.Rectangle(0, 0, 10, 20)

    class FakeEllipseStencil
      drawn: false
      draw: (node) =>
        @drawn = true
        new paper.Path.Rectangle(0, 0, 10, 20)