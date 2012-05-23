require('lib/setup')

# Spine = require('spine')
Drawings = require('controllers/drawings')

class App extends Spine.Controller
  constructor: ->
    super
    
    Spine.Route.add("/drawing/:id", (params) =>
      @switchTo =>
        console.log(@$('#content'))
        new Drawings(el: @$('#content'), id: params.id)
    )
    
    Spine.Route.setup()
    Spine.Route.navigate("/drawing/2")
    
  switchTo: (constructor) ->
    @currentController.release() if @currentController
    @currentController = constructor()
      
module.exports = App
    