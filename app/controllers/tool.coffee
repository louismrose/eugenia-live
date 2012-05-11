Link = require('models/link')
Node = require('models/node')

class Tool extends paper.Tool
  onKeyDown: (event) ->
    if (event.key is 'delete')
      selection = paper.project.selectedItems[0]
      selection.model.destroy() if selection

  changeSelectionTo: (item) ->
    @clearSelection()
    @select(item)

  clearSelection: ->
    paper.project.activeLayer.selected = false
  
  select: (item) ->
    item.selected = true
    
module.exports = Tool