# Rendering changes
* Fix updateDrawingCache
** create node / create link
** delete node / delete link
** move node
** undo of each of the above
* move and updatePosition / updateSegments methods both adjust the canvas element => seems redundant?
* Don't select labels when select node canvas elements
* Does undoing a shape also undo the deletion of its links? If not, this is a bug.
* The label of a node is no longer updated when its property changes after that node is moved
* Move views/drawings/shapes/label.coffee. Probably to the viewmodel folder?
* Factor out LinkCanvasElement and NodeCanvasElement classes from CanvasElement
* Tests for CanvasElement, Canvas, etc
* Move paper logic out of NodeShape and LinkShape and into the viewmodel layer
* Promote Elements#getOption to a class in its own right, and add some tests
* Labels for Links

# Yeoman (migration from Hem)
## Building an app ready for deployment
* Investigate Heroku generator for Yeoman
* Substitute almond for require.js in production? grunt-requirejs had support for this, but has been removed from yeoman as it was bloated and the author unresponsive.


# Testing
* Need a few end-to-end tests for core functionality
* Add unit tests for LinkTool

# Issues
* Refactor Eugenia notation and retest
* Don't update properties view when link tool is active?

# Features

## Live collaboration
* Build a commander that communicates with Pusher (and wraps the Commander class, like LoggingCommander)
* Switch palette editing to command-based API

## Palette editor
* Better error reporting for parsing of invalid JSON and EuGENia
* Investigate Google prettify for highlighting JSON and EuGENia code
* Graphical alternative to JSON / EuGENia metamodelling languages
* Preview palette items (e.g. little icons next to names or a thumbnail shown when hovering)

## Routing
* Gracefully handle invalid ids in routes

## Drawing export
* Export drawing as SVG
* Export model as XML / JSON

## Links
* Allow properties and labels
* Arrowheads
    * Trim links at the intersection with nodes
    * Figure out the maths for determining which way the last curve of a path is facing

## Palette constraints
* Type constraints for links
* Cardinality constraints for links

## Conformance checking / migration
* Implement the selection view properly
* Update selection view when the selection in the canvas changes
* Combo box that can change an element's type
* Label that can restore deleted shapes to the palette
* Problems model and marker rendering
* NodeShape listener that adds markers when a used nodeshape is deleted

## Allow more than one palette per drawing
* Use case: switch between tabular and graphical view for seating plan DSL

## Tools
* Port tool (use case: associating guests with tables in the seating plan DSL)
* Compartment tool

# Refactoring
* Renderers are beginning to look anaemic -> separate presentation from domain model?
* Update to latest versions of Hem and Spine
* Update to latest version of Twitter bootstrap