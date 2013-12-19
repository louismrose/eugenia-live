define [
  'paper'
], (paper) ->

  class CompositePath
    constructor: (@members) ->
      @_path = new paper.Group(@_paperMembers())
    
    _paperMembers: ->
      member._path for member in @members
    
    linkToViewModel: (viewModel) =>
      @_path.viewModel = viewModel
      member.linkToViewModel(viewModel) for member in @members
    
    remove: ->
      @_path.remove()
      
    select: ->
      @_path.selected = true
    
    position: ->
      @_path.position
    