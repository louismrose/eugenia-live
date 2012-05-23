LinkTool = require('controllers/link_tool')
NodeTool = require('controllers/node_tool')
SelectTool = require('controllers/select_tool')
NodeShape = require ('models/node_shape')
LinkShape = require ('models/link_shape')

class Toolbox extends Spine.Controller
  events:
    "click a[data-tool]": "reactToToolSelection" 
    "click button[data-tool-parameter-value]": "reactToToolConfiguration" 
  
  constructor: ->
    super
    @tools =
      node:   new NodeTool(drawing: @item)
      select: new SelectTool(drawing: @item)
      link:   new LinkTool(drawing: @item)
    @currentTool = @tools.node
    @render()
    
  render: =>
    context = {nodeShapes: NodeShape.all(), linkShapes: LinkShape.all()}
    @html require('views/toolbox')(context)
  
  reactToToolSelection: (event) =>
    toolName = $(event.currentTarget).data('tool')    
    @switchTo(toolName)
  
  reactToToolConfiguration: (event) =>
    button = $(event.currentTarget)
    value = button.data('toolParameterValue')
    key = button.parent().data('toolParameter')
    @configureCurrentToolWith(key, value)
    
  switchTo: (toolName) =>
    throw "There is no tool named '#{toolName}'" unless @tools[toolName]
    @currentTool = @tools[toolName]
    @currentTool.activate()
  
  configureCurrentToolWith: (parameterKey, parameterValue) =>
    @currentTool.parameters or= {}
    @currentTool.parameters[parameterKey] = parameterValue
    
module.exports = Toolbox