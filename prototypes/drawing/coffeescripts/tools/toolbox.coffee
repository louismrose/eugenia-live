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
    
  reactToToolSelection: ->
    $('body').on('click', 'a[data-tool]', (event) ->
      tool_name = $(this).attr('data-tool')    
      tool = grumble.tools[tool_name]    
      tool.activate() if tool
    )

  reactToToolConfiguration: ->
    $('body').on('click', 'button[data-tool-parameter-value]', (event) ->
      value = $(this).attr('data-tool-parameter-value')
      key = $(this).parent().attr('data-tool-parameter')
      grumble.tool.parameters or= {}
      grumble.tool.parameters[key] = value
    )