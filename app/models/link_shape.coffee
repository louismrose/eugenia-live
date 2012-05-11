class LinkShape extends Spine.Model
  @configure "Shape", "name", "color", "style"
  @extend Spine.Model.Local
  
  constructor: (attributes) ->
    super
  
  displayName: =>
    @name.charAt(0).toUpperCase() + @name.slice(1)
    
  draw: (segments) =>
    path = new paper.Path(segments)
    path.strokeColor = @color
    path.dashArray = [4, 4] if @style is "dashed"
    path
    
module.exports = LinkShape