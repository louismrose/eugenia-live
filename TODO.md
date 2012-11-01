# Deploy
* Alpha label

# Testing
* Need a few end-to-end tests for core functionality
* Add unit tests for LinkTool

# Issues
* Refactor Eugenia notation and retest
* Don't update properties view when link tool is active?

# Features

## Routing
* Gracefully handle invalid ids in routes

## Drawing export
* Export drawing as SVG
* Export model as XML / JSON

## Palette editor
* Better error reporting for parsing of invalid JSON and EuGENia
* Investigate Google prettify for highlighting JSON and EuGENia code
* Graphical alternative to JSON / EuGENia metamodelling languages
* Preview palette items (e.g. little icons next to names or a thumbnail shown when hovering)

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
* Fix duplication of rootFor in DraftLink and Tool