###
  @depend ../namespace.js
###
class grumble.Tool extends paper.Tool
  onKeyDown: (event) ->
    if (event.key is 'delete')
      selection = paper.project.selectedItems[0]
      if selection 
        if selection.closed
          grumble.Node.destroy(selection.spine_id)
        else
          grumble.Link.destroy(selection.spine_id)


  # extract the information needed to reconstruct
  # this path (and nothing more)
  filterPath: (path) ->
    for s in path.segments
      point: {x: s.point.x, y: s.point.y}
      handleIn: {x: s.handleIn.x, y: s.handleIn.y}
      handleOut: {x: s.handleOut.x, y: s.handleOut.y}

  changeSelectionTo: (item) ->
    @clearSelection()
    @select(item)

  clearSelection: ->
    paper.project.activeLayer.selected = false
  
  select: (item) ->
    item.selected = true