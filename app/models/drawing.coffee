#Spine = require('spine')
Node = require('models/node')
Link = require ('models/link')

class Drawing extends Spine.Model
  @configure "Drawing"
  @hasMany "nodes", Node
  @hasMany "links", Link
  @extend Spine.Model.Local
  
  @findOrCreate: (id) ->
    if @exists(id) then @find(id) else @create(id: id)
      
module.exports = Drawing