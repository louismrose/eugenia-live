define [
  'paper'
  'viewmodels/drawings/element'
], (paper, Element) ->

  class Polygon extends Element
    constructor: (@element) ->
      super(@element) 
    
    defaults: =>
      @_merge({ sides: 3, radius: 50 }, super())
    
    createPath: (node) ->
      centre = new paper.Point(0, 0)
      new paper.Path.RegularPolygon(centre, @_sides(node), @_radius(node))
    
    _sides: (node) ->
      @resolve(node, 'sides')
      
    _radius: (node) ->
      @resolve(node, 'radius')