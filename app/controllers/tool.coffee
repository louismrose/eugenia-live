Node = require('models/node')

class Tool extends paper.Tool
  
  constructor: (options) ->
    super
    @drawing = options.drawing
  
  setParameter: (parameterKey, parameterValue) ->
    @parameters or= {}
    @parameters[parameterKey] = parameterValue
  
  onKeyDown: (event) ->
    if (event.key is 'delete')
      selection = paper.project.selectedItems[0]
      @rootFor(selection).model.destroy() if selection

  isNode: (item) ->
    item and (@rootFor(item).model instanceof Node)

  changeSelectionTo: (item) ->
    @clearSelection()
    @select(item)

  clearSelection: ->
    paper.project.activeLayer.selected = false
    @drawing.clearSelection()
    @drawing.save()
  
  select: (item) ->
    root = @rootFor(item)
    root.selected = true
    @drawing.select(root.model)
    @drawing.save()
  
  selection: ->
    item = paper.project.selectedItems[0]
    @rootFor(item) if item
  
  rootFor: (item) ->
    if item.parent instanceof paper.Layer
      item
    else
      item.parent
    
module.exports = Tool