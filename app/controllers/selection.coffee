Spine = require('spine')

class Selection extends Spine.Controller  
  constructor: ->
    super
    @render()
    
  render: =>
    if @item
      @html require('views/drawings/selection')(@item)
    
module.exports = Selection