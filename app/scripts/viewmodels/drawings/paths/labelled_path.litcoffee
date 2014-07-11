### LabelledPath
This class encapsulates the logic necessary to draw a path with a label attached.

    define [
      'paper'
      'viewmodels/drawings/paths/composite_path'
      'viewmodels/drawings/paths/label'
    ], (paper, CompositePath, Label) ->

A LabelledPath is a CompositePath that contains a Label and the underlying `path`.
The Label is created using the properties passed to the LabelledPath.

      class LabelledPath extends CompositePath
        constructor: (@path, properties) ->
          @label = new Label(properties)
          super([@path, @label], properties)

Redrawing a LabelledPath is achieved by delegating to the Label. Note that the 
properties for the underlying `path` are not known to the LabelledPath, so redrawing
of the underlying `path` happens elsewhere.

        redraw: (properties) =>
          @label.redraw(properties)
          @label.setPosition(@_labelPosition(properties)) if @_properties.placement isnt "none"

We calculate the position of the label differently depending on the value of the
`placement` property. An `external` label is positioned below the bottom centre
point of the bounds of underlying `path`. An `internal` label is positioned at the 
position of `path`.

        _labelPosition: (properties) =>
          switch properties.placement
            when "external"
              @path.bottomCenter().add([0, 20]) # nudge outside shape
            when "internal"
              @path.position() # align with centre and middle of shape

Selecting a LabelledPath selects only the underlying `path` because Paper.js puts
a bounding box (e.g., with drag points) around highlighted objects, and we don't
want to see these bounding boxes on labels.

        select: ->
          @path.select()
          
A LabelledPath can be reshaped by reshaping its underlying path which we presume
is a Line, and by moving its Label.
        
        reshape: (offset, moveStart, moveEnd) ->
          @path.reshape(offset, moveStart, moveEnd)
          @label.move(offset)