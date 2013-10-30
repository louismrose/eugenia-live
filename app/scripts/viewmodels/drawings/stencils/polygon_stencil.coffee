define [
  'paper'
  'viewmodels/drawings/stencils/stencil'
  'viewmodels/drawings/stencils/stencil_specification'
], (paper, Stencil, StencilSpecification) ->

  class PolygonStencil extends Stencil
    defaultStencilSpecification: =>
      new StencilSpecification(x: 0, y: 0, fillColor: "white", borderColor: "black")
    
    draw: (node) =>
      path = @createPath(node)
      path.position = new paper.Point(node.position).add(@resolve(node, 'x'), @resolve(node, 'y'))
      path.fillColor = @resolve(node, 'fillColor')
      path.strokeColor = @resolve(node, 'borderColor')
      path
      
    # Subclasses must implement this method
    createPath: (node) ->
      throw new Error("Instantiate a subclass rather than this class directly.")