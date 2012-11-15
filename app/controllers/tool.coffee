Node = require('models/node')
Link = require('models/link')

class Tool extends paper.Tool
  
  constructor: (options) ->
    super
    @hitTester = options.hitTester
    @hitTester or= new PaperHitTester
    @drawing = options.drawing
  
  setParameter: (parameterKey, parameterValue) ->
    @parameters or= {}
    @parameters[parameterKey] = parameterValue

  onKeyDown: (event) ->
    if (event.key is 'delete')
      e.destroy() for e in @selection()
      @clearSelection()

  changeSelectionTo: (nodeOrLink) ->
    @clearSelection()
    @select(nodeOrLink)

  clearSelection: ->
    @drawing.clearSelection()
  
  select: (nodeOrLink) ->
    @drawing.select(nodeOrLink)
  
  selection: ->
    @drawing.selection


class PaperHitTester
  nodeOrLinkAt: (point) ->
    result = @nodeAt(point)
    result = @linkAt(point) unless result
    result
  
  linkAt: (point) ->
    @xAt(point, Link)
  
  nodeAt: (point) ->
    @xAt(point, Node)

  xAt: (point, type) ->
    hitResult = paper.project.hitTest(point)
    hitResult.item.model if hitResult and (hitResult.item.model instanceof type)
    
module.exports = Tool