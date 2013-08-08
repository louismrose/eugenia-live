define [], () ->

  class ChangeProperty
    constructor: (@element, @property, @newValue) ->
  
    run: =>
      @oldValue = @element.getPropertyValue(@property)
      @element.setPropertyValue(@property, @newValue)
  
    undo: =>
      @element.setPropertyValue(@property, @oldValue)