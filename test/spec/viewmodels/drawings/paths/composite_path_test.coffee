define [
  'paper'
  'viewmodels/drawings/paths/composite_path'
], (paper, CompositePath) ->

  describe 'CompositePath', ->
    beforeEach ->
      @member1 = createPathSpy()
      @member2 = createPathSpy()
      @path = createCompositePath([@member1, @member2])
    
    it 'creates a Paper.js group', ->
      expect(@path._paperItem instanceof paper.Group).toBeTruthy()

    it 'inserts the Paper.js items of the members into the group', ->
      expect(@path._paperItem.children).toEqual([@member1._paperItem, @member2._paperItem])
    
    describe 'linkToViewModel', ->  
      beforeEach ->
        @viewModel = {}
        @path.linkToViewModel(@viewModel)
    
      it 'sets property', ->
        expect(@path._paperItem.viewModel).toBe(@viewModel)
      
      it 'delegates to linkToViewModel on members', ->
        expect(@member1.linkToViewModel).toHaveBeenCalledWith(@viewModel)
        expect(@member2.linkToViewModel).toHaveBeenCalledWith(@viewModel)
        
        
    createCompositePath = (members = []) ->  
      paper = new paper.PaperScope()
      paper.project = new paper.Project()
      new CompositePath(members)
    
    createPathSpy = ->
      path = jasmine.createSpyObj('path', ['linkToViewModel'])
      path._paperItem = new paper.Path.Rectangle(0, 0, 10, 20)
      path