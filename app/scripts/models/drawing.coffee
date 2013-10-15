define [
  'spine'
  'models/node'
  'models/link'
  'spine.relation'
], (Spine, Node, Link) ->

  class Drawing extends Spine.Model
    @configure 'Drawing', 'name', 'cache', 'selection'
    @hasOne 'palette', 'models/palette'
    @hasMany 'nodes', 'models/node'
    @hasMany 'links', 'models/link'
  
    constructor: ->
      super
      @bind("destroy", @destroyChildren)

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
      
    clearSelection: ->
      @selection = undefined
      @save()
      @trigger('selectionChanged')
    
    select: (element) ->
      @selection = {id: element.id, type: element.constructor.className}
      @save()
      @trigger('selectionChanged')
      
    getSelection: ->
      if @selection is undefined
        undefined
      else if @selection.type is "Node"
        Node.find(@selection.id)
      else
        Link.find(@selection.id)