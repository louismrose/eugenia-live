class Point
  constructor: (@x, @y) ->
  
  add: (other) ->
    new Point(@x + other.x, @y + other.y)
  
  subtract: (other) ->
    add(-other)
  
  invert: ->
    new Point(-@x, -@y)

module.exports = Point