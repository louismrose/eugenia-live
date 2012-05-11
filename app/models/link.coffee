#Spine = require('spine')
class Link extends Spine.Model
  @configure "Link", "sourceId", "targetId", "segments", "strokeColor", "strokeStyle"
  @extend Spine.Model.Local
  
  # TODO duplication with Node
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @updateSegments(attributes.segments)
  
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
  
  toPath: =>
    new paper.Path(@toSegments())
  
  toSegments: =>
    for s in @segments
      new paper.Segment(s.point, s.handleIn, s.handleOut)
  
  reconnectTo: (node, origin) ->
    @newPath = @toPath()
    
    if @sourceId is node.id
      offset = @newPath.firstSegment.point.subtract(origin)
      @newPath.removeSegments(0, @newPath.segments.size - 2)
      @newPath.insert(0, node.position.add(offset))

    if @targetId is node.id
      offset = @newPath.lastSegment.point.subtract(origin)
      @newPath.removeSegments(1, @newPath.segments.size - 1)
      @newPath.add(node.position.add(offset))

    @newPath.simplify(100)

    @updateSegments(@newPath.segments)
    @save()
      
module.exports = Link