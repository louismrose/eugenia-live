Spine = require('spine')

class Palette extends Spine.Model
  @configure 'Palette'
  @hasMany 'nodeShapes', 'models/node_shape'
  @hasMany 'linkShapes', 'models/link_shape'
  @belongsTo 'drawing', 'models/drawing'
  @extend Spine.Model.Local
  
  constructor: ->
    super
    @bind("destroy", @destroyChildren)
    
  destroyChildren: ->
    ns.destroy() for ns in @nodeShapes().all()
    ls.destroy() for ls in @linkShapes().all()
    
module.exports = Palette