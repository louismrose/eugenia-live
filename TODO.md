# Rendering changes
* Fix move bug: create node, move it, reload, position goes back to origin

* LinkCanvasElement
    * Remove @canvas? Or at least move it to the end of the param list of constructor?
    * Convert to .litcoffee
    * Trim intersection of link with nodes rather than just hiding the path underneath the nodes
* CanvasElement
    * Try to hide paper.js internals? (e.g., .firstChild.selected = true in select method)
    * Convert to .litcoffee
    * Can we reuse (share) stencils between instances?
* Test and refactor NodeCanvasElement
    * Bring under test
    * Follow same pattern in LinkCavasElement for manipulating paper.js items
    * Convert to .litcoffee
* Test and refactor CanvasElementFactory
   * Bring under test
   * Convert to .litcoffee 
* Test and refactor canvas
* Test and refactor LabelledStencil
    * Ensure external labels are displayed near the midpoint of a link's path
* Fix updateDrawingCache
    * create node / create link
    * delete node / delete link
    * move node
    * undo of each of the above
* Work through codebase, migrating variables and functions to private (i.e., prefixed with an underscore) where appropriate


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