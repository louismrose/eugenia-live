class paper.NodeTool extends grumble.Tool
  parameters: {'shape' : 'rectangle', 'fill_colour' : 'white', 'stroke_colour' : 'black', 'stroke_style' : 'solid'}
  
  onMouseDown: (event) ->
    switch this.parameters['shape']
      when "rectangle" then n = new paper.Path.Rectangle(event.point, new paper.Size(100, 50))
      when "circle" then n = new paper.Path.Circle(event.point, 50)
      when "star" then n = new paper.Path.Star(event.point, 5, 20, 50)

    n.fillColor = this.parameters['fill_colour']
    n.strokeColor = this.parameters['stroke_colour']
    n.dashArray = if this.parameters['stroke_style'] is 'solid' then [10, 0] else [10, 4]
    paper.project.selectedItems[0].selected = false if (paper.project.selectedItems[0])
