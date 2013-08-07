Spine = require('spine')
ChangeProperty = require('models/commands/change_property')

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
    @commander.run(new ChangeProperty(@selection, property, newValue))
  
module.exports = Selection