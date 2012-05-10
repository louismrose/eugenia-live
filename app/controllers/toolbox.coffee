LinkTool = require('controllers/link_tool')
NodeTool = require('controllers/node_tool')
SelectTool = require('controllers/select_tool')

class Toolbox
  @tools = {}
  @currentTool = null
  
  install: ->
    @createTools()
    @reactToToolSelection()
    @reactToToolConfiguration()
    
  createTools: ->
    @tools =
      node:   new NodeTool()
      select: new SelectTool()
      link:   new LinkTool()
    @currentTool = @tools.node
    
  reactToToolSelection: =>
    toolbox = this
    $('body').on('click', 'a[data-tool]', (event) ->
      tool_name = $(this).attr('data-tool')    
      toolbox.switchTo(tool_name)
    )

  reactToToolConfiguration: =>
    toolbox = this
    $('body').on('click', 'button[data-tool-parameter-value]', (event) ->
      value = $(this).attr('data-tool-parameter-value')
      key = $(this).parent().attr('data-tool-parameter')
      toolbox.configureCurrentToolWith(key, value)
    )
    
  switchTo: (tool_name) =>
    @currentTool = @tools[tool_name]    
    @currentTool.activate() if @currentTool
  
  configureCurrentToolWith: (parameter_key, parameter_value) =>
    @currentTool.parameters or= {}
    @currentTool.parameters[parameter_key] = parameter_value
    
module.exports = Toolbox