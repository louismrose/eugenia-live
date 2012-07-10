Spine = require('spine')

class Palette extends Spine.Model
  @configure 'Palette'
  @hasMany 'nodeShapes', 'models/node_shape'
  @hasMany 'linkShapes', 'models/link_shape'
  @belongsTo 'drawing', 'models/drawing'
  @extend Spine.Model.Local
    
module.exports = Palette