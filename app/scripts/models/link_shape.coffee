define [
  'spine'
  'models/helpers/label'
  'spine.relation'
], (Spine, Label) ->

  class LinkShape extends Spine.Model
    @configure "LinkShape", "name", "properties", "label", "color", "style"
    @belongsTo 'palette', 'models/palette'
  
    constructor: (attributes) ->
      super
      @createDelegates()
      @bind("update", @createDelegates)
      @bind("destroy", @destroyLinks)
  
    createDelegates: =>
      @_label = new Label(@label)
  
    defaultPropertyValues: =>
      defaults = {}
      defaults[property] = "" for property in @properties if @properties
      defaults
      
    displayName: =>
      @name.charAt(0).toUpperCase() + @name.slice(1)
    
    draw: (link) =>
      @_label.draw(link, @drawPath(link))
      
    drawPath: (link) =>
      path = new paper.Path(link.segments)
      path.strokeColor = @color
      path.dashArray = [4, 4] if @style is "dash"
      path
  
    destroyLinks: ->
      link.destroy() for link in require('models/link').findAllByAttribute("shape", @id)