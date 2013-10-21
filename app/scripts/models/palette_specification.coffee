define [
  'spine'
  'models/palette'
], (Spine, Palette) ->

  class StateMachinePaletteSpecification
    @create: ->
      PaletteSpecification.create(name: "State Machine", json: @json()).save()
  
    @json: ->
      '{
        "name": "State Machine",
        "nodeShapes": [
          {
            "name": "State",
            "properties": ["name", "recurrent"],
            "label" : {
              "for" : "name",
              "color" : "green",
              "placement" : "internal",
              "length" : 15
            },
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
            "name": "Initial",
            "properties": ["name"],
            "elements": [
              {
                "figure": "ellipse",
                "size": {"width": 20, "height": 20},
                "fillColor": "black",
                "borderColor": "black"
              }
            ]
          },
          {
            "name": "Final",
            "properties": ["name"],
            "elements": [
              {
                "figure": "ellipse",
                "size": {"width": 20, "height": 20},
                "fillColor": "white",
                "borderColor": "black"
              },
              {
                "figure": "ellipse",
                "size": {"width": 14, "height": 14},
                "fillColor": "black",
                "borderColor": "black"
              }
            ]
          }
        ],
        "linkShapes": [
          {
            "name": "Transition",
            "color": "black",
            "style": "solid"
          },
          {
            "name": "Dependency",
            "color": "gray",
            "style": "dash"
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
            "name": "Net",
            "elements": [
              {
                "figure": "ellipse",
                "size": {"width": 60, "height": 60},
                "fillColor": "white",
                "borderColor": "black"
              }
            ]
          },
          {
            "name": "Arc",
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
            "name": "Transition",
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