class grumble.Toolbox
  install: ->
    this.createTools()
    this.reactToToolSelection()
    this.reactToToolConfiguration()
    
  createTools: ->
    window.tools =
      node:   new paper.NodeTool()
      select: new paper.SelectTool()
      link:   new paper.LinkTool()
    
  reactToToolSelection: ->
    $('body').on('click', 'a[data-tool]', (event) ->
      tool_name = $(this).attr('data-tool')    
      tool = window.tools[tool_name]    
      tool.activate() if tool
    )

  reactToToolConfiguration: ->
    $('body').on('click', 'button[data-tool-parameter-value]', (event) ->
      value = $(this).attr('data-tool-parameter-value')
      key = $(this).parent().attr('data-tool-parameter')
      paper.tool.parameters = {} unless paper.tool.parameters
      paper.tool.parameters[key] = value
    )