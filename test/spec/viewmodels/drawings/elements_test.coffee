define [
  'paper'
  'viewmodels/drawings/elements'
], (paper, Elements) ->

  describe 'Elements', ->
    it 'creates a child for every stencil in array', ->
      result = createStencils([{ figure: "rectangle" }, { figure: "ellipse" }])
      expect(result.children.length).toBe(2)

    it 'passes options to children via factory', ->
      factory = new FakeFactory()
      stencils = [
        { figure: "rectangle", borderColor: "blue" }, 
        { figure: "ellipse", size : { width: 10, height: 50} }
      ]
      createStencils(stencils, factory)
      
      expect(factory.rectangle).toEqual({ figure: "rectangle", borderColor: "blue" })
      expect(factory.ellipse).toEqual({ figure: "ellipse", size : { width: 10, height: 50} })
    
    createStencils = (stencils, factory = new FakeFactory()) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      elements = new Elements(stencils, factory)
      result = elements.draw({})

    class FakeFactory
      rectangle: {}
      ellipse: {}
      
      stencilFor: (stencilSpec) =>
        switch stencilSpec.figure
          when "rectangle"
            @rectangle = stencilSpec
            draw: (node) =>
              new paper.Path.Rectangle(0, 0, 10, 20)

          when "ellipse"
            @ellipse = stencilSpec
            draw: (node) =>
              new paper.Path.Oval(new paper.Rectangle(0, 0, 30, 40))