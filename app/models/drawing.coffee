#Spine = require('spine')
Node = require('models/node')
Link = require ('models/link')

class Drawing extends Spine.Model
  @configure "Drawing", "name", "palette"
  @hasMany "nodes", Node
  @hasMany "links", Link
  @extend Spine.Model.Local
  
module.exports = Drawing