# Spine.Model.Local uses JSON for seralisation and hence
# cannot contain cyclic structures. Paper.js's paths 
# are sometimes cyclic, so we filter the Paper.js structure
# to the bare essentials (which will be acyclic)
class SimplifiesSegments
  for: (segments) =>
    if segments
      @simplified(segment) for segment in segments
  
  simplified: (s) ->
    {
      point: {x: s.point.x, y: s.point.y}
      handleIn: {x: s.handleIn.x, y: s.handleIn.y}
      handleOut: {x: s.handleOut.x, y: s.handleOut.y}
    }

module.exports = SimplifiesSegments