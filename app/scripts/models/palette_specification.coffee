define [
  'spine'
  'models/palette'
], (Spine, Palette) ->

  class StateMachinePaletteSpecification
    @create: ->
      PaletteSpecification.create(json: @json()).save()
  
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
                "size": {"width": 10, "height": 10},
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
                "size": {"width": 10, "height": 10},
                "fillColor": "white",
                "borderColor": "black"
              },
              {
                "figure": "ellipse",
                "size": {"width": 7, "height": 7},
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
      PaletteSpecification.create(json: @json()).save()
    
    @json: ->
      '{
        "name": "Petri net",
        "nodeShapes": [
          {
            "name": "Net",
            "elements": [
              {
                "figure": "ellipse",
                "size": {"width": 30, "height": 30},
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


  class ConcentrationPaletteSpecification
    @create: ->
      PaletteSpecification.create(json: @json()).save()
  
    @json: ->
      '{
        "name": "Concentration",
        "nodeShapes": [
          {
            "name": "External influence",
            "properties": [
              "name"
            ],
            "label": {
              "for": [
                "name"
              ],
              "color": "black",
              "placement": "internal",
              "length": 15,
              "pattern": "{0}"
            },
            "elements": [
              {
                "figure": "rectangle",
                "size": {
                  "width": 100,
                  "height": 100
                },
                "fillColor": "white",
                "borderColor": "black",
                "x": 0,
                "y": 0
              },
              {
                "figure": "path",
                "points": [
                  {"x": -20, "y" : 40},
                  {"x": 50,  "y" : 40},
                  {"x": 40,  "y" : 10},
                  {"x": 80,  "y" : 50},
                  {"x": 40,  "y" : 90},                
                  {"x": 50,  "y" : 60},
                  {"x": -20, "y" : 60},
                  {"x": -20, "y" : 40}
                ],
                "fillColor": "white",
                "borderColor": "green",
                "x": -30,
                "y": -35
              }
            ]
          },
          {
            "name": "Process",
            "properties": [
              "name"
            ],
            "label": {
              "for": [
                "name"
              ],
              "color": "green",
              "placement": "internal",
              "length": 15,
              "pattern": "{0}"
            },
            "elements": [
              {
                "figure": "rounded",
                "size": {
                  "width": 100,
                  "height": 50
                },
                "fillColor": "#FFFFCC",
                "borderColor": "black",
                "x": 0,
                "y": 0
              }
            ]
          },
          {
            "name": "Concentration",
            "properties": [
              "name"
            ],
            "label": {
              "for": [
                "name"
              ],
              "color": "green",
              "placement": "internal",
              "length": 15,
              "pattern": "{0}"
            },
 
            "elements": [
              {
                "figure": "polygon",
                "fillColor": "#FFCCFF",
                "borderColor": "black",
                "sides" : 5,
                "radius" : 50,
                "x": 0,
                "y": 0
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
      
  class PhysicalSystemPaletteSpecification
    @create: ->  
      PaletteSpecification.create(json: @json()).save()
      
    @json: ->
      '{
        "name": "Physical system",
        "nodeShapes": [
          {
            "name": "Surface",
            "elements": [
              {
                "figure": "rectangle",
                "size": {"width": 250, "height": 10},
                "fillColor": "gray",
                "borderColor": "black"
              }
            ]
          },
          {
            "name": "Mass",
            "properties": ["Weight"],
  
            "elements": [
              {
                "figure": "rectangle",
                "size": {"width": 75, "height": 75},
                "fillColor": "blue",
                "borderColor": "black"
              },
              {
                "figure": "ellipse",
                "size": {"width": 5, "height": 5},
                "fillColor": "red",
                "borderColor": "black"
              }
            ]
          },
          {
            "name": "Spring",
            "properties": ["Strength", "Length"],
            "elements": [
              {
                "figure": "path",
                "fillColor": "none",
                "borderColor": "black",
                "points" : [
                  {"x":0, "y":0},
                  {"x":-10, "y":10},
                  {"x": 10, "y":30},
                  {"x":-10, "y":50},
                  {"x": 10, "y":70},
                  {"x":-10, "y":90},
                  {"x": 0, "y":100}
                ]
              }
            ]
          }
        ],
        "linkShapes": [
          {
            "name": "Attach",
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
      ConcentrationPaletteSpecification.create()
      PhysicalSystemPaletteSpecification.create()
  
    constructor: (name, json) ->
      super(name, json)
      @name = @data().name if @data().name
  
    instantiate: =>
      p = Palette.create().save()

      if @data().nodeShapes
        for nsData in @data().nodeShapes
          p.nodeShapes().create(nsData).save()
    
      if @data().linkShapes
        for lsData in @data().linkShapes
          p.linkShapes().create(lsData).save()
      p
      
    data: =>
      JSON.parse(@json)
    