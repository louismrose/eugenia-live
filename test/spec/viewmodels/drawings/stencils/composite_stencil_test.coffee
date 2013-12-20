define [
  'viewmodels/drawings/stencils/composite_stencil'
  'viewmodels/drawings/paths/rectangle'
  'viewmodels/drawings/paths/ellipse'
], (CompositeStencil, Rectangle, Ellipse) ->

  describe 'CompositeStencil', ->
    beforeEach ->
      @stencil1 = createRectangleStencilSpy()
      @stencil2 = createEllipseStencilSpy()
      @path = createCompositePath([@stencil1, @stencil2])
    
    it 'draws a CompositePath', ->
      expect(@path.constructor.name).toBe('CompositePath')
    
    it 'calls draw for every stencil in array', ->
      expect(@stencil1.draw).toHaveBeenCalled()
      expect(@stencil2.draw).toHaveBeenCalled()
    
    it 'resulting CompositePath contains a child for every stencil in array', ->
      expect(@path.members.length).toBe(2)
    
    
    createCompositePath = (stencils) ->  
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