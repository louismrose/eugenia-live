Spine = require('spine')

class Selection extends Spine.Controller
  events:
    "change input[data-property]": "updatePropertyValue"
  
  constructor: ->
    super
    @item.bind("update", @render)
    @render()
    
  render: =>
    if @item
      @selection = null
      @selection = @item.selection[0] if @item.selection.length is 1
      @html require('views/drawings/selection')(@selection)
  
  updatePropertyValue: (event) =>
    property = $(event.target).data('property')
    newValue = $(event.target).val()
    @selection.setPropertyValue(property, newValue)
    @selection.save()
  
module.exports = Selection