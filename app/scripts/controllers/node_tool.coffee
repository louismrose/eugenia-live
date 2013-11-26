define [
  'controllers/tool'
  'models/commands/create_node'
  'controllers/toolbox'
], (Tool, CreateNode, Toolbox) ->

  class NodeTool extends Tool
    parameters: {'shape' : null}
  
    onMouseDown: (event) =>
      if @parameters.shape
        @parameters.position = { x: event.point.x, y: event.point.y }
        @run(new CreateNode(@drawing, @parameters))
        #[THANOS] Change the highlighted tool to select and then get the global variable myToolbox and switch the current tool to select
        document.getElementById("toolbox").getElementsByClassName("active")[0].setAttribute('class', '')
        document.getElementById("sel").setAttribute('class', 'active')
        myToolbox.switchTo("select")
      
    onMouseMove: (event) =>
      if @parameters.shape
        @clearSelection()
        @select(@hitTester.nodeAt(event.point))
