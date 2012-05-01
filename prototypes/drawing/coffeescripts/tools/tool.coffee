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
        
    else if (event.modifiers.command and event.key is 'c')
        window.clipboard = paper.project.selectedItems[0]

    else if (event.modifiers.command and event.key is 'v')
      if (window.clipboard)
        paper.project.selectedItems[0].selected = false if (paper.project.selectedItems[0])
        copy = window.clipboard.clone()
        copy.position.x += 10
        copy.position.y += 10
        copy.selected = true
        window.clipboard = copy