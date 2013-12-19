define [
  'paper'
  'viewmodels/drawings/stencils/composite_stencil'
  'viewmodels/drawings/paper/rectangle'
  'viewmodels/drawings/paper/ellipse'
], (paper, CompositeStencil, Rectangle, Ellipse) ->

  describe 'CompositeStencil', ->  
    it 'draws a CompositePath', ->
      result = createCompositeStencil()
      expect(result.constructor.name).toBe('CompositePath')
    
    it 'calls draw for every stencil in array', ->
      rectangle = new FakeRectangleStencil()
      ellipse = new FakeEllipseStencil()
      result = createCompositeStencil([rectangle, ellipse])
      
      expect(rectangle.drawn).toBeTruthy()
      expect(ellipse.drawn).toBeTruthy()
    
    it 'resulting CompositePath contains a child for every stencil in array', ->
      result = createCompositeStencil([new FakeRectangleStencil(), new FakeEllipseStencil()])
      expect(result.members.length).toBe(2)
    
    createCompositeStencil = (stencils) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      composite = new CompositeStencil(stencils)
      result = composite.draw({})

    class FakeRectangleStencil
      drawn: false
      draw: (node) =>
        @drawn = true
        new Rectangle(10, 20)

    class FakeEllipseStencil
      drawn: false
      draw: (node) =>
        @drawn = true
        new Ellipse(10, 20)