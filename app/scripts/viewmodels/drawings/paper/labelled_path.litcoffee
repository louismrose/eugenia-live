### LabelledPath

    define [
      'paper'
    ], (paper) ->

      
A label encapsulates that state necessary to render a label for a particular
drawing element and add it to a Paper.js Item.

      class LabelledPath
        
We wrap the Paper.js Item in a Group. We add a PointText element to the Group if
the `placement` property has a value other than `none`.
        
        constructor: (color, content, @_length, placement, @_labelledItem) ->
          @_label = @_createPointText(color, content, placement)
          @_path = new paper.Group([@_labelledItem._path, @_label])
        
        # FIXME hack; needs redesign (could viewmodel be passed in via constructor?)
        linkToViewModel: (viewModel) =>
          @_path.viewModel = viewModel 
          @_label.viewModel = viewModel
          @_labelledItem.linkToViewModel(viewModel)
        
        # FIXME hack; needs redesign  
        segments: ->
          @_labelledItem.segments()
        
        move: (offset, isSource, isTarget) ->
          @_moveLabel(offset)
          @_labelledItem.move(offset, isSource, isTarget)
        
        _moveLabel: (offset) ->
          @_label.position.x += offset.x
          @_label.position.y += offset.y
          
        remove: =>
          @_path.remove()
    
        select: ->
          @_labelledItem.select()
  
        position: ->
          @_label.position
        
        content: ->
          @_label.content
        
        fillColor: ->
          @_label.fillColor
        
We create the Paper.js PointText, after calculating the fill colour, content, and 
position of the label.

        _createPointText: (color, content, placement) ->
          new paper.PointText
            justification: 'center'
            fillColor: color
            content: @_trim(content)
            position: @_position(placement)
      
When a property value changes, the content of the label might need to be updated.
Therefore, we bind to change events on the element's PropertySet.
      
        refresh: (content) =>
          @_path.content = @_trim(content)
          # FIXME this should call canvas.updateDrawingCache()
          paper.view.draw()

We calculate the content of a label as the value of its `text` property, trimmed
to a maximum size dictated by its `length` property.

        _trim: (text) ->
          return "" unless text
          return text unless text.length > @_length
          return text.substring(0, @_length-3).trim() + "..."

We calculate the position of a label differently depending on the value of its
`placement` property. An `external` label is positioned below the bottom centre
point of the bounds of the item to which the label is attached. An `internal` 
label is positioned at the centre of the bounds of the item to which the label 
is attached.

        _position: (placement) ->
          switch placement
            when "external"
              @_labelledItem.bottomCenter().add([0, 20]) # nudge outside shape
            when "internal"
              @_labelledItem.position() # align with centre and middle of shape  
  