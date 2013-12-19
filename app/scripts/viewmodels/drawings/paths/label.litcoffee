### Label
This class is responsible for drawing labels, by using a Paper.js PointText.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class Label extends Path
        constructor: (properties) ->
          @_text = new BoundedString(properties.text, properties.length)
        
          super(
            new paper.PointText
              justification: 'center'
              fillColor: properties.color
              content: @_text.value()
          )
          
        text: ->
          @_text.value()
          
        setText: (text) =>
          @_paperItem.content = @_text.setValue(text)


BoundedString is a string literal with a maximum length.
        
      class BoundedString
        constructor: (@_value, @_maximumLength) ->
        
If the value of the BoundedString exceeds the maximum length, the value is 
truncated.

        value: ->
          return "" unless @_value
          return @_value unless @_value.length > @_maximumLength
          return @_value.substring(0, @_maximumLength-3).trim() + "..."
        
        setValue: (value) ->
          @_value = value
          @value()
          
          
We return the Label class for import by other classes via require.js.
        
      Label