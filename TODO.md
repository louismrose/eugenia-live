# Deploy
* Alpha label

# Testing
* Need a few end-to-end tests for core functionality
* Add unit tests for LinkTool

# Issues
* Don't update properties view when link tool is active?
* Add tests for reconstructing linkshapes and then refactor EugeniaNotation
* Some issues with Eugenia notation...
    * Attributes aren't included
    * Colours need to be translated to RGB values

# Features
* Export drawing as SVG

## Landing page
* Overview the tool
* Link to the paper
* Warn about alpha, local storage, etc


## Syntax highlighting
* Investigate Google prettify for highlighting JSON and EuGENia code


## Customisable palettes
* Is controller/routing organisation appropriate?
    * Create / update palette items
    * Don't create / update invalid palette items
    * Better error reporting for parsing of JSON and EuGENia
* Preview palette items (e.g. little icons next to names or a thumbnail shown when hovering)
* Graphical alternative to JSON / EuGENia metamodelling languages

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