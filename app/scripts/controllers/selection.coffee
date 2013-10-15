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
      @item.bind("selectionChanged", @observeSelection)
      @render()
    
    observeSelection: =>
      @selection.properties.unbind("propertyChanged propertyRemoved") if @selection
      @selection = @item.getSelection() if @item
      @selection.properties.bind("propertyChanged propertyRemoved", @render) if @selection
      @render()
    
    render: =>
      @html SelectionTemplate({ selection: @selection }) if @item
  
    updatePropertyValue: (event) =>
      property = $(event.target).data('property')
      newValue = $(event.target).val()
      @commander.run(new ChangeProperty(@item.getSelection(), property, newValue))