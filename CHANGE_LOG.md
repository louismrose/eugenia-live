# Change Log

## v0.2.0 (July 2014)
* Switched to a new (viewmodel-based) rendering engine, which is much more performant than the previous version.
* Added support for controlling the appearance of Nodes and Links via their
  properties, using `${}` syntax. For example, `width: "${rate}"`
* Added syntax highlighting for defining palette items via CodeMirror.
* Removed support for Java Message Format expressions in labels. The new `${propertyName}` syntax is now preferred.
* Removed raw Paper.js Paths as possible shapes.

* Fixed a bug which caused additional lines to be rendered when a node and its links were moved.

### Development environment
* Switched to Yeoman and Grunt rather than Spine's Hem to allow more flexibility in our development environment.
* Switched to Bower and RequireJS for managing dependencies.
* Added support for building SCSS.
* Updated to Paper.js v0.99
* Added support for literate Coffeescript in our build environment, and started to document the codebase in this manner.

## v0.1.0 (June 2013)
* First stable release