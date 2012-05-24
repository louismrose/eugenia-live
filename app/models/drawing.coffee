#Spine = require('spine')
Palette = require ('models/palette')
Node = require('models/node')
Link = require ('models/link')

class Drawing extends Spine.Model
  @configure 'Drawing', 'name'
  @belongsTo 'palette', Palette
  @hasMany 'nodes', Node
  @hasMany 'links', Link
  @extend Spine.Model.Local
  
module.exports = Drawing