LinkTool = require('controllers/link_tool')
NodeTool = require('controllers/node_tool')
SelectTool = require('controllers/select_tool')

class Toolbox extends Spine.Controller
  events:
    "click a[data-tool]": "reactToToolSelection" 
    "click button[data-tool-parameter-value]": "reactToToolConfiguration" 
  
  constructor: ->
    super
    @tools =
      node:   new NodeTool()
      select: new SelectTool()
      link:   new LinkTool()
    @currentTool = @tools.node
    
  reactToToolSelection: (event) =>
    tool_name = jQuery(event.target).attr('data-tool')    
    @currentTool = @tools[tool_name]
    @currentTool.activate() if @currentTool

  reactToToolConfiguration: (event) =>
    button = jQuery(event.target)
    value = button.attr('data-tool-parameter-value')
    key = button.parent().attr('data-tool-parameter')
    @currentTool.parameters or= {}
    @currentTool.parameters[key] = value
    
module.exports = Toolbox