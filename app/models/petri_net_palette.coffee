NodeShape = require('models/node_shape')
LinkShape = require('models/link_shape')

class PetriNetPalette
  constructor: ->
    new NodeShape(
      name: "net",
      elements: [{
        figure: "circle",
        size: {width: 30, height: 30},
        fillColor: "white",
        borderColor: "black"
      }]
    ).save()
    
    new NodeShape(
      name: "arc",
      elements: [{
        figure: "rectangle",
        size: {width: 10, height: 50},
        fillColor: "black",
        borderColor: "black"
      }]
    ).save()

    new LinkShape(
      name: "transition"
      color: "black"
      style: "solid"
    ).save()
    
module.exports = PetriNetPalette