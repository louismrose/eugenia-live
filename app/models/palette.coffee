Spine = require('spine')

class Palette extends Spine.Model
  @configure 'Palette'
  @hasMany 'nodeShapes', 'models/node_shape'
  @hasMany 'linkShapes', 'models/link_shape'
  @hasMany 'drawings', 'models/drawing'
  @extend Spine.Model.Local
    
module.exports = Palette