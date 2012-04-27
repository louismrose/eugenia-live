###
  @depend tool.js
###
class paper.NodeTool extends grumble.Tool
  parameters: {'shape' : 'rectangle', 'fill_colour' : 'white', 'stroke_colour' : 'black', 'stroke_style' : 'solid'}
  
  onMouseDown: (event) ->
    switch @parameters['shape']
      when "rectangle" then n = new paper.Path.Rectangle(event.point, new paper.Size(100, 50))
      when "circle" then n = new paper.Path.Circle(event.point, 50)
      when "star" then n = new paper.Path.Star(event.point, 5, 20, 50)

    n.links = [] # Domain model (FIXME: separate from node, which is part of the view)
    n.fillColor = @parameters['fill_colour']
    n.strokeColor = @parameters['stroke_colour']
    n.dashArray = if @parameters['stroke_style'] is 'solid' then [10, 0] else [10, 4]
    paper.project.selectedItems[0].selected = false if (paper.project.selectedItems[0])

