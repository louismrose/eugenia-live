NodeShape = require('models/node_shape')
LinkShape = require('models/link_shape')

class StateMachinePalette
  constructor: ->
    new NodeShape(
      name: "state",
      elements: [
        {
          figure: "rounded",
          size: {width: 100, height: 50},
          fillColor: "white",
          borderColor: "black"
        }
      ]
    ).save()
    
    new NodeShape(
      name: "initial",
      elements: [
        {
          figure: "circle",
          size: {width: 10, height: 10},
          fillColor: "black",
          borderColor: "black"
        }
      ]
    ).save()

    new NodeShape(
      name: "final",
      elements: [
        {
          figure: "circle",
          size: {width: 10, height: 10},
          fillColor: "white",
          borderColor: "black"
        },
        {
          figure: "circle",
          size: {width: 7, height: 7},
          fillColor: "black",
          borderColor: "black"
        }
      ]
    ).save()
    
    new LinkShape(
      name: "transition"
      color: "black"
      style: "solid"
    ).save()
    
    new LinkShape(
      name: "dependency"
      color: "gray"
      style: "dashed"
    ).save()
    
module.exports = StateMachinePalette