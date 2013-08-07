Spine = require('spine')

class LinkShape extends Spine.Model
  @configure "LinkShape", "name", "color", "style"
  @belongsTo 'palette', 'models/palette'
  
  constructor: (attributes) ->
    super
    @bind("destroy", @destroyLinks)
  
  displayName: =>
    @name.charAt(0).toUpperCase() + @name.slice(1)
    
  draw: (segments) =>
    path = new paper.Path(segments)
    path.strokeColor = @color
    path.dashArray = [4, 4] if @style is "dash"
    path
  
  destroyLinks: ->
    link.destroy() for link in require('models/link').findAllByAttribute("shape", @id)
    
module.exports = LinkShape