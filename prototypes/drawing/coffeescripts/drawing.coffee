# Only executed our code once the DOM is ready.
window.onload = ->
  # Get a reference to the canvas object
  canvas = document.getElementById('myCanvas')
  # Create an empty project and a view for the canvas:
  paper.setup(canvas)      
  # Draw the view now:
  paper.view.draw()
  
  $('body').on('click', 'a[data-tool]', (event) ->
    tool_name = $(this).attr('data-tool')    
    tool = window.tools[tool_name]    
    tool.activate() if tool
  )
  
  $('body').on('click', 'button[data-tool-parameter-value]', (event) ->
    value = $(this).attr('data-tool-parameter-value')
    key = $(this).parent().attr('data-tool-parameter')
    paper.tool.parameters = {} unless paper.tool.parameters
    paper.tool.parameters[key] = value
  )
  
  window.tools = {}
    
  window.tools['node'] = new paper.Tool()
  window.tools['node'].parameters = {'shape' : 'rectangle', 'fill_colour' : 'white', 'stroke_colour' : 'black', 'stroke_style' : 'solid'}
  window.tools['node'].onMouseDown = (event) ->
    switch this.parameters['shape']
      when "rectangle" then n = new paper.Path.Rectangle(event.point, new paper.Size(100, 50))
      when "circle" then n = new paper.Path.Circle(event.point, 50)
      when "star" then n = new paper.Path.Star(event.point, 5, 20, 50)
      
    n.fillColor = this.parameters['fill_colour']
    n.strokeColor = this.parameters['stroke_colour']
    n.dashArray = if this.parameters['stroke_style'] is 'solid' then [10, 0] else [10, 4]
    
  window.tools['select'] = new paper.Tool()
  window.tools['select'].onMouseDown = (event) ->
    hitResult = paper.project.hitTest(event.point)    
    paper.project.activeLayer.selected = false
    hitResult.item.selected = true if hitResult
  
  window.tools['select'].onMouseDrag = (event) ->
    if (paper.project.selectedItems[0])
      paper.project.selectedItems[0].position = event.point
  
  window.tools['select'].onKeyDown = (event) ->
    if (event.key is 'delete')
      paper.project.selectedItems[0].remove() if paper.project.selectedItems[0]

    else if (event.modifiers.command and event.key is 'c')
        window.clipboard = paper.project.selectedItems[0]

    else if (event.modifiers.command and event.key is 'v')
      if (window.clipboard)
        paper.project.selectedItems[0].selected = false if (paper.project.selectedItems[0])
        copy = clipboard.clone()
        copy.position.x += 10
        copy.position.y += 10
        copy.selected = true
