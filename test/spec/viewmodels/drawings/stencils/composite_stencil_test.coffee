define [
  'viewmodels/drawings/stencils/composite_stencil'
  'viewmodels/drawings/paths/rectangle'
  'viewmodels/drawings/paths/ellipse'
], (CompositeStencil, Rectangle, Ellipse) ->

  describe 'CompositeStencil', ->
    beforeEach ->
      @path1 = new Rectangle(10, 20)
      @path2 = new Ellipse(10, 20)
      @stencil1 = createStencilSpy(@path1)
      @stencil2 = createStencilSpy(@path2)
      @stencil = new CompositeStencil([@stencil1, @stencil2])
      @path = @stencil.draw({})
    
    it 'draws a CompositePath', ->
      expect(@path.constructor.name).toBe('CompositePath')
    
    it 'calls draw for every stencil in array', ->
      expect(@stencil1.draw).toHaveBeenCalled()
      expect(@stencil2.draw).toHaveBeenCalled()
    
    it 'resulting CompositePath contains a child for every stencil in array', ->
      expect(@path.members.length).toBe(2)
    
    describe 'redraw', ->
      it 'delegates to redraw on members', ->
        element = { name: "Fake" }
        @stencil.redraw(element, @path)
        
        expect(@stencil1.redraw).toHaveBeenCalledWith(element, @path1)
        expect(@stencil2.redraw).toHaveBeenCalledWith(element, @path2)
    
    
    createStencilSpy = (path) ->
      stencil = jasmine.createSpyObj('stencil', ['draw', 'redraw'])
      stencil.draw.andReturn(path)
      stencil