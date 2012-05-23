Link = require('models/link')
Node = require('models/node')

class Tool extends paper.Tool
  
  constructor: (options) ->
    super
    @drawing = options.drawing    
  
  onKeyDown: (event) ->
    if (event.key is 'delete')
      selection = paper.project.selectedItems[0]
      selection.model.destroy() if selection

  isNode: (item) ->
    item and (item.model instanceof Node)

  changeSelectionTo: (item) ->
    @clearSelection()
    @select(item)

  clearSelection: ->
    paper.project.activeLayer.selected = false
  
  select: (item) ->
    if item.parent instanceof paper.Layer
      item.selected = true
    else
      item.parent.selected = true
  
  selection: ->
    item = paper.project.selectedItems[0]
    if item
      if item.parent instanceof paper.Layer
        item
      else
        item.parent
    
module.exports = Tool