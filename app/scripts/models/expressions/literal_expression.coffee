define [
], () ->

  class LiteralExpression
    @appliesFor: (expression) ->
      true
      
    constructor: (@expression) ->
      
    evaluate: ->
      @expression