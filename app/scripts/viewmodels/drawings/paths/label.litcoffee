### Label
This class is responsible for drawing labels, by using a Paper.js PointText.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class Label extends Path
        constructor: (properties) ->
          @_text = new BoundedString(properties.text, properties.length)
          super(new paper.PointText(justification: 'center'), properties)
        
        redraw: (properties) =>
          @_text.fullText = properties.text if properties.text
          @_text.maximumLength = properties.length if properties.length
          @_paperItem.fillColor = properties.color
          @_paperItem.content = @_text.value()
          @_paperItem.visible = properties.placement isnt "none"
        
        text: ->
          @_text.value()
          
BoundedString is a string literal with a maximum length.
        
      class BoundedString
        constructor: (@fullText, @maximumLength) ->
        
If the text of the BoundedString exceeds the maximum length, the value is 
truncated.

        value: ->
          return "" unless @fullText
          return @fullText unless @fullText.length > @maximumLength
          return @fullText.substring(0, @maximumLength-3).trim() + "..."
        
We return the Label class for import by other classes via require.js.
        
      Label