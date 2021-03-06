### CompositePath
This class is responsible for drawing Paths that are composed of one of more
other Paths.

    define [
      'paper'
      'viewmodels/drawings/paths/path'
    ], (paper, Path) ->

      class CompositePath extends Path
      
A CompositePath comprises an array of other Paths, known as its `members`. To 
render a CompositePath, we construct a Paper.js Group that contains the Paper.js 
items of `members`.
      
        constructor: (@members, properties) ->
          super(new paper.Group(@_paperMembers()), properties)

        _paperMembers: ->
          member._paperItem for member in @members
    
When a CompositePath is asked to be linked to a viewModel, we link the Paper.js 
group to the view model and, additionally, request that all of our members are 
linked to the same view model.
    
        linkToViewModel: (viewModel) =>
          super
          member.linkToViewModel(viewModel) for member in @members