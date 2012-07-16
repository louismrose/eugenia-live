Spine = require('spine')
Palette = require('models/palette')


class StateMachinePaletteSpecification
  @create: ->
    PaletteSpecification.create(name: "State Machine", json: @json()).save()
  
  @json: ->
    '{
      "name": "State Machine",
      "nodeShapes": [
        {
          "name": "state",
          "properties": ["name", "recurrent"],
          "elements": [
            {
              "figure": "rounded",
              "size": {"width": 100, "height": 50},
              "fillColor": "white",
              "borderColor": "black"
            }
          ]
        },
        {
          "name": "initial",
          "properties": ["name"],
          "elements": [
            {
              "figure": "circle",
              "size": {"width": 10, "height": 10},
              "fillColor": "black",
              "borderColor": "black"
            }
          ]
        },
        {
          "name": "final",
          "properties": ["name"],
          "elements": [
            {
              "figure": "circle",
              "size": {"width": 10, "height": 10},
              "fillColor": "white",
              "borderColor": "black"
            },
            {
              "figure": "circle",
              "size": {"width": 7, "height": 7},
              "fillColor": "black",
              "borderColor": "black"
            }
          ]
        }
      ],
      "linkShapes": [
        {
          "name": "transition",
          "color": "black",
          "style": "solid"
        },
        {
          "name": "dependency",
          "color": "gray",
          "style": "dashed"
        }
      ]
    }'
  


class PetriNetPaletteSpecification
  @create: ->  
    PaletteSpecification.create(name: "Petri net", json: @json()).save()
    
  @json: ->
    '{
      "name": "Petri net",
      "nodeShapes": [
        {
          "name": "net",
          "elements": [
            {
              "figure": "circle",
              "size": {"width": 30, "height": 30},
              "fillColor": "white",
              "borderColor": "black"
            }
          ]
        },
        {
          "name": "arc",
          "elements": [
            {
              "figure": "rectangle",
              "size": {"width": 10, "height": 50},
              "fillColor": "black",
              "borderColor": "black"
            }
          ]
        }
      ],
      "linkShapes": [
        {
          "name": "transition",
          "color": "black",
          "style": "solid"
        }
      ]
    }'


class PaletteSpecification extends Spine.Model
  @configure 'PaletteSpecification', 'name', 'json'
  
  @fetch: ->
    StateMachinePaletteSpecification.create()
    PetriNetPaletteSpecification.create()
  
  instantiate: =>
    data = JSON.parse(@json)
    
    p = Palette.create().save()

    if data.nodeShapes
      for nsData in data.nodeShapes
        p.nodeShapes().create(nsData).save()
    
    if data.linkShapes
      for lsData in data.linkShapes
        p.linkShapes().create(lsData).save()
    
    p
     
module.exports = PaletteSpecification