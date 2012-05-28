#Spine = require('spine')

class StateMachinePaletteFactory
  @create: ->
    p = new Palette(name: "State machine").save()
    
    p.nodeShapes().create(
      name: 'state',
      elements: [
        {
          figure: 'rounded',
          size: {width: 100, height: 50},
          fillColor: 'white',
          borderColor: 'black'
        }
      ]
    ).save()
    
    p.nodeShapes().create(
      name: 'initial',
      elements: [
        {
          figure: 'circle',
          size: {width: 10, height: 10},
          fillColor: 'black',
          borderColor: 'black'
        }
      ]
    ).save()

    p.nodeShapes().create(
      name: 'final',
      elements: [
        {
          figure: 'circle',
          size: {width: 10, height: 10},
          fillColor: 'white',
          borderColor: 'black'
        },
        {
          figure: 'circle',
          size: {width: 7, height: 7},
          fillColor: 'black',
          borderColor: 'black'
        }
      ]
    ).save()
    
    p.linkShapes().create(
      name: 'transition'
      color: 'black'
      style: 'solid'
    ).save()
    
    p.linkShapes().create(
      name: 'dependency'
      color: 'gray'
      style: 'dashed'
    ).save()
  


class PetriNetPaletteFactory
  @create: ->
    p = new Palette(name: "Petri net").save()
    
    p.nodeShapes().create(
      name: "net",
      elements: [{
        figure: "circle",
        size: {width: 30, height: 30},
        fillColor: "white",
        borderColor: "black"
      }]
    ).save()
    
    p.nodeShapes().create(
      name: "arc",
      elements: [{
        figure: "rectangle",
        size: {width: 10, height: 50},
        fillColor: "black",
        borderColor: "black"
      }]
    ).save()

    p.linkShapes().create(
      name: "transition"
      color: "black"
      style: "solid"
    ).save()
  

class Palette extends Spine.Model
  @configure 'Palette', 'name'
  @hasMany 'nodeShapes', 'models/node_shape'
  @hasMany 'linkShapes', 'models/link_shape'
  @hasMany 'drawings', 'models/drawing'
  
  @fetch: ->
    StateMachinePaletteFactory.create()
    PetriNetPaletteFactory.create()
    
module.exports = Palette