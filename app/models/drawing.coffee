Spine = require('spine')

class Drawing extends Spine.Model
  @configure 'Drawing', 'name', 'selection'
  @hasOne 'palette', 'models/palette'
  @hasMany 'nodes', 'models/node'
  @hasMany 'links', 'models/link'
  @extend Spine.Model.Local
  
  constructor: ->
    super
    @bind("destroy", @destroyChildren)
  
  select: (element) ->
    @selection or= []
    @selection.push(element)
    
  clearSelection: ->
    @selection = []
  
  validate: ->
    "Name is required" unless @name
    
  destroyChildren: ->
    node.destroy() for node in @nodes().all()
    link.destroy() for link in @links().all()
    @palette().destroy() if @palette()
  
module.exports = Drawing