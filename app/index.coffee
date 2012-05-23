require('lib/setup')

# Spine = require('spine')
Drawings = require('controllers/drawings')

class App extends Spine.Controller
  constructor: ->
    super
    
    Spine.Route.add("/drawing/:id", (params) ->
      new Drawings(el: @$('#content'), id: params.id)
    )
    
    Spine.Route.setup()
    Spine.Route.navigate("/drawing/2")
      
module.exports = App
    