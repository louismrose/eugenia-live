define [], () ->

  class ChangeProperty
    constructor: (@element, @property, @newValue) ->
  
    run: =>
      @oldValue = @element.properties.get(@property)
      @element.properties.set(@property, @newValue)
  
    undo: =>
      @element.properties.set(@property, @oldValue)