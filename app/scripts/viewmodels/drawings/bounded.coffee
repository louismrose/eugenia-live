define [
  'paper'
  'viewmodels/drawings/element'
], (paper, Element) ->

  class Bounded extends Element
    defaults: =>
      @_merge({ size: { width: 100, height: 100 } }, super())
    
    _width: (node) =>
      @resolve(node, 'size.width')
    
    _height: (node) =>
      @resolve(node, 'size.height')