define [
  'require'
  'spine'
  'spine.relation'
], (require, Spine) ->

  class LinkShape extends Spine.Model
    @configure "LinkShape", "name", "properties", "label", "color", "style"
    @belongsTo 'palette', 'models/palette'
  
    constructor: (attributes) ->
      super
      @properties or= []
      @bind("destroy", @destroyLinks)
  
    defaultPropertyValues: =>
      defaults = {}
      defaults[property] = "" for property in @properties
      defaults
      
    displayName: =>
      @name.charAt(0).toUpperCase() + @name.slice(1)
      
    destroyLinks: ->
      link.destroy() for link in require('models/link').findAllByAttribute("shape", @id)