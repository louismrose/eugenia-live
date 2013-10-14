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
      @item.bind("selectionChanged", @render)
      @render()
    
    render: =>
      if @item
        @html SelectionTemplate({ selection: @item.getSelection() })
  
    updatePropertyValue: (event) =>
      property = $(event.target).data('property')
      newValue = $(event.target).val()
      @commander.run(new ChangeProperty(@item.getSelection(), property, newValue))