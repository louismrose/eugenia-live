Link = require('models/link')
Node = require('models/node')

class Tool extends paper.Tool
  onKeyDown: (event) ->
    if (event.key is 'delete')
      selection = paper.project.selectedItems[0]
      if selection 
        if selection.closed
          Node.destroy(selection.spine_id)
        else
          Link.destroy(selection.spine_id)

  changeSelectionTo: (item) ->
    @clearSelection()
    @select(item)

  clearSelection: ->
    paper.project.activeLayer.selected = false
  
  select: (item) ->
    item.selected = true
    
module.exports = Tool