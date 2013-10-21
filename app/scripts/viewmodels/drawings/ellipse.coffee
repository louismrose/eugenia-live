define [
  'paper'
  'viewmodels/drawings/bounded'
], (paper, Bounded) ->

  class Ellipse extends Bounded
    createPath: (node) ->
      new paper.Path.Oval(new paper.Rectangle(0, 0, @_width(node), @_height(node)))