define [
  'paper'
  'viewmodels/drawings/bounded'
], (paper, Bounded) ->

  class RoundedRectangle extends Bounded
    createPath: (node) ->
      bounds = new paper.Rectangle(0, 0, @_width(node), @_height(node))
      new paper.Path.RoundRectangle(bounds, new paper.Size(10, 10))