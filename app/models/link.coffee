# Spine = require('spine')
Node = require('models/node')

class Link extends Spine.Model
  @configure "Link", "sourceId", "targetId", "segments", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
  
  # TODO duplication with Node
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @updateSegments(attributes.segments) if attributes and attributes.segments
    @bind "save", @addToNodes
    @bind "destroy", @removeFromNodes
  
  updateSegments: (segments) =>
    @removePossibleCyclesFromSegments(segments)

  # Spine.Model.Local uses JSON for seralisation and hence
  # cannot contain cyclic structures. Paper.js's paths 
  # are sometimes cyclic, so we filter the Paper.js structure
  # to the bare essentials (which will be acyclic)
  removePossibleCyclesFromSegments: (segments) =>
    @segments = (@removePossibleCyclesFromSegment(s) for s in segments)
  
  removePossibleCyclesFromSegment: (s) ->
    {
      point: {x: s.point.x, y: s.point.y}
      handleIn: {x: s.handleIn.x, y: s.handleIn.y}
      handleOut: {x: s.handleOut.x, y: s.handleOut.y}
    }
      
  addToNodes: =>
    @source().addLink(@id)
    @target().addLink(@id)
    
  removeFromNodes: =>
    @source().removeLink(@id) if Node.exists(@sourceId)
    @target().removeLink(@id) if Node.exists(@targetId)

  source: =>
    Node.find(@sourceId)
  
  target: =>
    Node.find(@targetId)
    
module.exports = Link