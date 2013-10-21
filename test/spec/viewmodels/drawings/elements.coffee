define [
  'paper'
  'viewmodels/drawings/elements'
], (paper, Elements) ->

  describe 'Elements', ->
    it 'creates a child for every element of array', ->
      result = createElements([{ figure: "rectangle" }, { figure: "ellipse" }])
      expect(result.children.length).toBe(2)

    it 'passes options to children via factory', ->
      factory = new FakeFactory()
      elements = [
        { figure: "rectangle", borderColor: "blue" }, 
        { figure: "ellipse", size : { width: 10, height: 50} }
      ]
      createElements(elements, factory)
      
      expect(factory.rectangle).toEqual({ figure: "rectangle", borderColor: "blue" })
      expect(factory.ellipse).toEqual({ figure: "ellipse", size : { width: 10, height: 50} })
    
    createElements = (elements, factory = new FakeFactory()) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      element = new Elements(elements, factory)
      result = element.draw({})

    class FakeFactory
      rectangle: {}
      ellipse: {}
      
      elementFor: (element) =>
        switch element.figure
          when "rectangle"
            @rectangle = element
            draw: (node) =>
              new paper.Path.Rectangle(0, 0, 10, 20)

          when "ellipse"
            @ellipse = element
            draw: (node) =>
              new paper.Path.Oval(new paper.Rectangle(0, 0, 30, 40))