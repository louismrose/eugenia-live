### LabelledPath
This class encapsulates the logic necessary to draw a path with a label attached. The
path to which a label is to be attached is termed the `labelledPath`. 

    define [
      'paper'
      'viewmodels/drawings/paths/composite_path'
      'viewmodels/drawings/paths/label'
    ], (paper, CompositePath, Label) ->

A LabelledPath is a CompositePath that contains a Label and the `labelledPath`.

      class LabelledPath extends CompositePath
        constructor: (@labelledPath, @_properties) ->
          @label = @_createLabel()
          super([@labelledPath, @label])

The Label is created using the properties passed to the LabelledPath, and positioned
relative to the `labelledPath`.

        _createLabel: ->
          label = new Label(@_properties)
          label.setPosition(@_labelPosition())
          label

We calculate the position of the label differently depending on the value of the
`placement` property. An `external` label is positioned below the bottom centre
point of the bounds of `labelledItem`. An `internal` label is positioned at the 
position of `labelledItem`.

        _labelPosition: ->
          switch @_properties.placement
            when "external"
              @labelledPath.bottomCenter().add([0, 20]) # nudge outside shape
            when "internal"
              @labelledPath.position() # align with centre and middle of shape  

Selecting a LabelledPath selects only the underlying `labelledPath` because Paper.js
puts a bounding box (e.g., with drag points) around highlighted objects, and we don't
want to see these bounding boxes on labels.

        select: ->
          @labelledPath.select()
          
Setting the text of a LabelledPath updates the text of the label.

        setText: (text) ->
          @label.setText(text)

A LabelledPath can be reshaped by reshaping its underlying path which we presume
is a Line, and by moving its Label.
        
        reshape: (offset, moveStart, moveEnd) ->
          @labelledPath.reshape(offset, moveStart, moveEnd)
          @label.move(offset)