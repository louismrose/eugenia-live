###
  @depend tool.js
###
class grumble.NodeTool extends grumble.Tool
  parameters: {'shape' : 'rectangle', 'fillColor' : 'white', 'strokeColor' : 'black', 'strokeStyle' : 'solid'}
  
  onMouseDown: (event) ->
    @parameters.position = event.point
    new grumble.Node(@parameters).save()
    @clearSelection()