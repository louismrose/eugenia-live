define [
  'paper'
], (paper) ->

  class Composite
    constructor: (@elements = []) ->
    
    draw: (node) =>
      new paper.Group(@_children(node))
    
    _children: (node) =>
      element.draw(node) for element in @elements
