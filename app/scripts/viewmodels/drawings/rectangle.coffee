define [
  'paper'
  'viewmodels/drawings/bounded'
], (paper, Bounded) ->

  class Rectangle extends Bounded
    createPath: (node) ->
      new paper.Path.Rectangle(0, 0, @_width(node), @_height(node))