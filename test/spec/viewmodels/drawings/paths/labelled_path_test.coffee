define [
  'paper'
  'viewmodels/drawings/paths/labelled_path'
], (paper, LabelledPath) ->

  describe 'LabelledPath', ->
    beforeEach ->
      @labelled = createPathSpy()
      
      @createLabelledPath = (properties = {}) ->
        new LabelledPath(@labelled, properties)
    
    describe 'on construction', -> 
      it 'when internal, it positions the label at the centre of the shape', ->
        path = @createLabelledPath(placement: 'internal')
        
        expect(path.label.position().x).toEqual(@labelled.position().x)
        expect(path.label.position().y).toEqual(@labelled.position().y)

      it 'when external, it positions the label below the bottom centre of the shape', ->
        path = @createLabelledPath(placement: 'external')
        
        expect(path.label.position().x).toEqual(@labelled.bottomCenter().x)
        expect(path.label.position().y).toEqual(@labelled.bottomCenter().y + 20)         

    describe 'linkToViewModel', ->  
      beforeEach ->
        @viewModel = {}
        @path = @createLabelledPath()
        @path.linkToViewModel(@viewModel)
    
      it 'sets property', ->
        expect(@path._paperItem.viewModel).toBe(@viewModel)
      
      it 'sets property on the underlying PointText of the label', ->
        expect(@path.label._paperItem.viewModel).toBe(@viewModel)

      it 'delegates to linkToViewModel on labelled path', ->
        expect(@labelled.linkToViewModel).toHaveBeenCalledWith(@viewModel)
    
    describe 'select', ->
      it 'delegates to the labelled path', ->
        path = @createLabelledPath()
        path.select()
        expect(@labelled.select).toHaveBeenCalled()

    describe 'move', ->
      beforeEach ->
        @origin = new paper.Point(10, 10)
        @offset = { x: 4, y: 5 }
        @isSource = true
        @isTarget = false
        
        @labelled = createPathSpy(@origin)
        @path = new LabelledPath(@labelled, placement: 'internal')
        @path.move(@offset, @isSource, @isTarget)
      
      it 'moves the underlying PointText', ->
        expect(@path.label.position().x).toBe(@origin.x + @offset.x)
        expect(@path.label.position().y).toBe(@origin.y + @offset.y)
      
      it 'delegates to linkToViewModel on labelled path', ->
        expect(@labelled.move).toHaveBeenCalledWith(@offset, @isSource, @isTarget)
      

    
    createPathSpy = (position = new paper.Point(50, 75) ) ->
      path = jasmine.createSpyObj('path', ['linkToViewModel', 'select', 'move', 'position', 'bottomCenter'])
      path.position.andReturn(position)
      path.bottomCenter.andReturn(new paper.Point(25, 75))
      path._paperItem = new paper.Path.Rectangle(0, 0, 10, 20)
      path