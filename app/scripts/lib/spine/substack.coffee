define [
  'spine'
  'spine.manager'
], (Spine) ->

  # SubStack by Niels van Hoorn
  # http://codecoverage.nl/blog/2012/04/17/nesting-stacks-in-spine-dot-js/

  class Spine.SubStack extends Spine.Stack
    constructor: ->
      for key,value of @routes
        do (key,value) =>
          @routes[key] = =>
            @active()
            @[value].active(arguments...)
      super