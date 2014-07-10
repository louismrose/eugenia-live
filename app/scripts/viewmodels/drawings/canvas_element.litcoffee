## CanvasElements
CanvasElements are the atoms of the viewmodel, and are responsible for maintaining
a binding between the view (i.e., a [Path](paths/path.litcoffee)) and the model
(e.g., a Node or Link).

CanvasElements provide the view with an interface for making changes to the 
underlying model, and provide a mechnanism for updating the view in response to
changes made to the underlying model.

    define [
      'spine'
    ], (Spine) ->

To keep the view up-to-date, CanvasElements respond to (Spine) events that 
indicate a change to the underlying model. For example, the view element 
should be removed when the underlying model element is destroyed.

      class CanvasElement extends Spine.Module
        @include(Spine.Events)

        constructor: (@_element, @_path, @_canvas) ->
          @_element.bind("destroy", @_path.remove)
          @_path.linkToViewModel(@)
    
CanvasElements also provide the view with mechanisms for changing the underlying
model, typically by invoking Commands. For example, calling destroy on a
CanvasElement causes the underlying model element to be deleted and (as a 
consequence of a callback) the corresponding view element to be removed.

        destroy: =>
          @_canvas.run(@_destroyCommand(@_canvas.drawing))

Occassionally, a CanvasElement updates the underlying model without issuing a 
Command, but this is perhaps an indication that a concept is missing from the
underlying model (e.g., a domain model of the application state).

        select: =>
          # TODO should this be implemented as some application state that
          # needs to be persisted, rather than as part of the underlying
          # drawing?
          @_canvas.clearSelection()
          @_path.select()
          @_element.select()