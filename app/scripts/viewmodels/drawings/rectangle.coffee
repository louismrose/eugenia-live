define [
  'paper'
  'viewmodels/drawings/element'
], (paper, Element) ->

  class Rectangle extends Element
    constructor: (@element) ->
      super(@element) 
    
    defaults: =>
      @_merge({ size: { width: 100, height: 100 } }, super())
    
    createPath: (node) ->
      new paper.Path.Rectangle(0, 0, @resolve(node, 'size.width'), @resolve(node, 'size.height'))
        