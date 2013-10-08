define [
  'spine'
  'models/commands/change_property'
  'views/drawings/selection'
], (Spine, ChangeProperty, SelectionTemplate) ->

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
        @html SelectionTemplate({ selection: @selection })
  
    updatePropertyValue: (event) =>
      property = $(event.target).data('property')
      newValue = $(event.target).val()
      @commander.run(new ChangeProperty(@selection, property, newValue))