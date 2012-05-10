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
    toolName = jQuery(event.target).attr('data-tool')    
    @switchTo(toolName)
  
  reactToToolConfiguration: (event) =>
    button = jQuery(event.target)
    value = button.attr('data-tool-parameter-value')
    key = button.parent().attr('data-tool-parameter')
    @configureCurrentToolWith(key, value)
    
  switchTo: (toolName) =>
    throw "There is no tool named '#{toolName}'" unless @tools[toolName]
    @currentTool = @tools[toolName]
    @currentTool.activate()
  
  configureCurrentToolWith: (parameterKey, parameterValue) =>
    @currentTool.parameters or= {}
    @currentTool.parameters[parameterKey] = parameterValue
    
module.exports = Toolbox