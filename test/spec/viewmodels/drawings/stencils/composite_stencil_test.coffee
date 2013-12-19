define [
  'viewmodels/drawings/stencils/composite_stencil'
  'viewmodels/drawings/paths/rectangle'
  'viewmodels/drawings/paths/ellipse'
], (CompositeStencil, Rectangle, Ellipse) ->

  describe 'CompositeStencil', ->
    beforeEach ->
      @rectangle = createRectangleStencilSpy()
      @ellipse = createEllipseStencilSpy()
      @path = createCompositeStencil([@rectangle, @ellipse])
    
    it 'draws a CompositePath', ->
      expect(@path.constructor.name).toBe('CompositePath')
    
    it 'calls draw for every stencil in array', ->
      expect(@rectangle.draw).toHaveBeenCalled()
      expect(@ellipse.draw).toHaveBeenCalled()
    
    it 'resulting CompositePath contains a child for every stencil in array', ->
      expect(@path.members.length).toBe(2)
    
    
    createCompositeStencil = (stencils) ->  
      composite = new CompositeStencil(stencils)
      result = composite.draw({})

    createRectangleStencilSpy = ->
      createStencilSpy(new Rectangle(10, 20))
    
    createEllipseStencilSpy = ->
      createStencilSpy(new Ellipse(10, 20))

    createStencilSpy = (path) ->
      stencil = jasmine.createSpyObj('stencil', ['draw'])
      stencil.draw.andReturn(path)
      stencil