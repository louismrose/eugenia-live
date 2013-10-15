define [
  'spine'
  'spine.relation'
], (Spine) ->

  class NodeShape extends Spine.Model
    @configure "NodeShape", "name", "properties", "label", "elements"
    @belongsTo 'palette', 'models/palette'
  
    constructor: (attributes) ->
      super
      @properties or= []
      @bind("destroy", @destroyNodes)
  
    defaultPropertyValues: =>
      defaults = {}
      defaults[property] = "" for property in @properties
      defaults
  
    displayName: =>
      @name.charAt(0).toUpperCase() + @name.slice(1)
  
    destroyNodes: ->
      node.destroy() for node in require('models/node').findAllByAttribute("shape", @id)