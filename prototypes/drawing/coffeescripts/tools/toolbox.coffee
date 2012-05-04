class grumble.Toolbox
  install: ->
    @createTools()
    @reactToToolSelection()
    @reactToToolConfiguration()
    
  createTools: ->
    grumble.tools =
      node:   new grumble.NodeTool()
      select: new grumble.SelectTool()
      link:   new grumble.LinkTool()
    grumble.tool = grumble.tools.node
    
  reactToToolSelection: ->
    $('body').on('click', 'a[data-tool]', (event) ->
      tool_name = $(this).attr('data-tool')    
      grumble.tool = grumble.tools[tool_name]    
      grumble.tool.activate() if grumble.tool
    )

  reactToToolConfiguration: ->
    $('body').on('click', 'button[data-tool-parameter-value]', (event) ->
      value = $(this).attr('data-tool-parameter-value')
      key = $(this).parent().attr('data-tool-parameter')
      grumble.tool.parameters or= {}
      grumble.tool.parameters[key] = value
    )