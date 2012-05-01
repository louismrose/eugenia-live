###
  @depend tool.js
###
class paper.NodeTool extends grumble.Tool
  parameters: {'shape' : 'rectangle', 'fillColor' : 'white', 'strokeColor' : 'black', 'strokeStyle' : 'solid'}
  
  onMouseDown: (event) ->
    attributes = @parameters
    attributes['position'] = event.point
    node = new grumble.Node(@parameters)
    console.log("created:")
    console.log(node)
    node.save()
    console.log("saved")
    paper.project.selectedItems[0].selected = false if (paper.project.selectedItems[0])