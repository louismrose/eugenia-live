define [
  'paper'
  'viewmodels/drawings/composite'
], (paper, Composite) ->

  describe 'Composite', ->  
    it 'draws a group', ->
      result = createComposite()
      expect(result instanceof paper.Group).toBeTruthy()
    
    it 'calls draw on for every element of array', ->
      rectangle = new FakeRectangle()
      ellipse = new FakeEllipse()
      result = createComposite([rectangle, ellipse])
      
      expect(rectangle.drawn).toBeTruthy()
      expect(ellipse.drawn).toBeTruthy()
    
    it 'creates a child for every element of array', ->
      result = createComposite([new FakeRectangle(), new FakeEllipse()])
      expect(result.children.length).toBe(2)
    
    createComposite = (elements) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      element = new Composite(elements)
      result = element.draw({})

    class FakeRectangle
      drawn: false
      draw: (node) =>
        @drawn = true
        new paper.Path.Rectangle(0, 0, 10, 20)

    class FakeEllipse
      drawn: false
      draw: (node) =>
        @drawn = true
        new paper.Path.Rectangle(0, 0, 10, 20)