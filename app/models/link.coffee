Spine = require('spine')
MovesPath = require('models/moves_path')
SimplifiesSegments = require('models/simplifies_segments')
LinkShape = require('models/link_shape')

class Link extends Spine.Model
  @configure "Link", "sourceId", "targetId", "segments", "shape"
  @belongsTo 'drawing', 'models/drawing'
  @extend Spine.Model.Local
  
  # TODO duplication with Node
  constructor: (attributes) ->
    super
    @k = v for k,v of attributes
    @updateSegments(attributes.segments) if attributes
  
  updateSegments: (segments) =>
    @segments = new SimplifiesSegments().for(segments)
  
  reconnectTo: (nodeId, offset) =>
    mover = new MovesPath(@toPath(), offset)
    mover.moveStart() if nodeId is @sourceId
    mover.moveEnd() if nodeId is @targetId
    @updateSegments(mover.finalise())
    @save()
    
  toPath: =>
    s = LinkShape.find(@shape)
    path = s.draw(@toSegments())
    path

  toSegments: =>
    for s in @segments
      new paper.Segment(s.point, s.handleIn, s.handleOut)
    
module.exports = Link
