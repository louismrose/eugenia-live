define [
  'spine'
  'spine.relation'
], (Spine) ->

  class Drawing extends Spine.Model
    @configure 'Drawing', 'name', 'selection', 'cache'
    @hasOne 'palette', 'models/palette'
    @hasMany 'nodes', 'models/node'
    @hasMany 'links', 'models/link'
  
    constructor: ->
      super
      @selection or= []
      @bind("destroy", @destroyChildren)
      @bind("selectionChanged", @updateCanvas)
  
    select: (element) ->
      if element
        @selection.push(element)
        # @save()
        @trigger("selectionChanged")
    
    clearSelection: ->
      @selection = []
      # @save()
      @trigger("selectionChanged")
  
    validate: ->
      "Name is required" unless @name
    
    destroyChildren: ->
      node.destroy() for node in @nodes().all()
      link.destroy() for link in @links().all()
      @palette().destroy() if @palette()

    addNode: (parameters) ->
      @nodes().create(parameters)
    
    addLink: (parameters) ->
      @links().create(parameters)

    updateCanvas: ->
      if paper.project
        paper.project.activeLayer.selected = false
        for element in @selection?
          element.select(paper.project.activeLayer)