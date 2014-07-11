## Viewmodels

A new rendering engine was released as part of v0.2.0 release. The motivation for the new rendering engine was to improve performance (by rendering view elements only when the underlying model element has changed and not whenever the canvas is refreshed) and to support animation.

Prior to release v0.2.0, rendering involved removing and redrawing any elements that changed. This scaled quite poorly when there were a large number of changing elements (e.g., a highly connected node) or frequent changes to a small number of elements (e.g., during animation of a diagram). The primary issues with the architecture were:

  * Whenever a model element changed, a [renderer](https://github.com/louismrose/eugenia-live/blob/v0.1/app/views/drawings/element_renderer.coffee) removed the existing Paper.js object draw a new one, which led to poor performance.
  * The model and the view were closely coupled, because the [NodeShape](https://github.com/louismrose/eugenia-live/blob/v0.1/app/models/node_shape.coffee) and [LinkShape](https://github.com/louismrose/eugenia-live/blob/v0.1/app/models/link_shape.coffee) model classes were responsible for instantiating Paper.js objects.
  * The code for determining the appearance of specific Nodes and Links was coupled to the code for instantiating Paper.js objects.
  * The code was difficult to test, because it was tightly coupled to Paper.js and because Paper.js objects rely on the presence of an HTML5 canvas.
  
The new architectures addresses all of theses issues by introducing the notion of viewmodels, which coordinate actions between view and model elements. A viewmodel exposes actions to the view which, for example, allow the properties of model elements to be changed. A viewmodel also observers the underlying model and propagates any necessary changes to the view.

The diagrams below summarise the new architecture. Broadly speaking, a command causes a change to some part of the model, which in turn causes an event to be triggered. An element of the viewmodel responds to this event by co-ordinating some change to corresponding part of the view. The responsibility for determining the appearance of a Node / Link is handled by a Stencil, whilst the responsibility for rendering the part of a view for a Node / Link is handled by a Path.

![Four sequence diagrams that describe the way in which adding, deleting, moving and property updating of nodes / links are propagated to the view via the new viewmodel architecture](../../../../raw/master/doc/design/viewmodel.png)

**Acknowledgments**: Thanks to Joost van Pinxten whose internship motivated this work and whose code inspired the new architecture.