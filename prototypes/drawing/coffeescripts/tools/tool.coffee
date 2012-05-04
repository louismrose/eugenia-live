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
