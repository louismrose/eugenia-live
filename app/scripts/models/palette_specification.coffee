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
            "name": "Net", "properties" : ["tokens"],
            "label" : {"for": "tokens"},
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
            ],
            "behavior": {
              "tick[true]": [
                "trigger(self, \'increment\')"
              ],
              "increment": [
                "tokens+=1"
              ]
            }
          }
        ],
        "linkShapes": [
          {
            "name": "Transition",
            "properties" : ["rate"],
            "label": {
              "for": [
                "rate"
              ],
              "placement": "external"
            },
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
            "name": "DNA",
            "properties": [
              "name",
              "copies"
            ],
            "label": {
              "for": [
                "name"
              ],
              "color": "white",
              "placement": "internal",
              "length": 15,
              "pattern": "{0}"
            },
            "elements": [
              {
                "figure": "rectangle",
                "size": {
                  "width": 100,
                  "height": 25
                },
                "fillColor": "blue",
                "borderColor": "black",
                "x": 0,
                "y": 0
              },
            ],
            "behavior": {}
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
            "name": "RNA",
            "properties": [
              "name",
              "copies"
            ],
            "label": {
              "for": [
                "name",
                "copies"
              ],
              "color": "black",
              "placement": "external",
              "length": 15,
              "pattern": "{0}/{1}"
            },
 
            "elements": [
              {
                "figure": "path",
                "fillColor": "orange",
                "borderColor": "black",
                "points": [
                  {"x": 0, "y": 0},
                  {"x": -10, "y": 10},
                  {"x": 10, "y": 40},
                  {"x": -15, "y": 60},
                  {"x": -5, "y": 60},
                  {"x": 20, "y": 40},
                  {"x": 0, "y": 10},
                  {"x": 10, "y": 0},
                  {"x": 0, "y": 0}
                ],
                "x": 0,
                "y": 0,
                "strokeColor": "black",
                "size": {
                  "width": 50,
                  "height": 100
                }
              },
              {
                "figure": "path",
                "fillColor": "orange",
                "borderColor": "black",
                "x": 20,
                "y": 10,
                "points": [
                  {"x": 0, "y": 0},
                  {"x": -10, "y": 10},
                  {"x": 10, "y": 40},
                  {"x": -15, "y": 60},
                  {"x": -5, "y": 60},
                  {"x": 20, "y": 40},
                  {"x": 0, "y": 10},
                  {"x": 10, "y": 0},
                  {"x": 0, "y": 0}
                ],
                "strokeColor": "black",
                "size": {
                  "width": 50,
                  "height": 100
                }
              },
              {
                "figure": "path",
                "fillColor": "orange",
                "borderColor": "black",
                "x": 45,
                "y": -5,
                "points": [
                  {"x": 0, "y": 0},
                  {"x": -10, "y": 10},
                  {"x": 10, "y": 40},
                  {"x": -15, "y": 60},
                  {"x": -5, "y": 60},
                  {"x": 20, "y": 40},
                  {"x": 0, "y": 10},
                  {"x": 10, "y": 0},
                  {"x": 0, "y": 0}
                ],
 
                "strokeColor": "black",
                "size": {
                  "width": 50,
                  "height": 100
                }
              }
            ],
            "behavior": {
              "tick[sim.time<=1;]": [
                "copies=0"
              ]
            },
            
            "name": "Degraded RNA",
            "properties": [
              "name",
              "copies"
            ],
            "label": {
              "for": [
                "name",
                "copies"
              ],
              "color": "black",
              "placement": "internal",
              "length": 15,
              "pattern": "{1}"
            },
            "elements": [
              {
                "figure": "path",
                "fillColor": "grey",
                "borderColor": "grey",
                "points" : [
                  {"x":0, "y":0},
                  {"x":-10, "y":10},
                  {"x": 10, "y":40},
                  {"x":-15, "y":60},
                  {"x":-5, "y":60},
                  {"x": 20, "y":40},
                  {"x":0, "y":10},
                  {"x":10, "y":0},
                  {"x":0, "y":0}
                ],
                "x": 0,
                "y": 0,
                "strokeColor": "black",
                "size": {
                  "width": 50,
                  "height": 100
                }
              }
            ],
            "behavior": {
              "tick[sim.time<=1;]": [
                "copies=0"
              ]
            },
            {
              "name": "Protein",
              "properties": [
                "name",
                "copies"
              ],
              "label": {
                "for": [
                  "name",
                  "copies"
                ],
                "color": "black",
                "placement": "external",
                "length": 15,
                "pattern": "{0}/{1}"
              },
           "elements": [
             {
               "figure": "ellipse",
               "fillColor": "#009900",
               "borderColor": "black",
               "size": {
                 "width": 50,
                 "height": 50
               },
               "x": 0,
               "y": 0
             },
             {
               "figure": "ellipse",
               "fillColor": "#009900",
               "borderColor": "black",
               "size": {
                 "width": 50,
                 "height": 50
               },
               "x": 30,
               "y": 55
             },
             {
               "figure": "ellipse",
               "fillColor": "#009900",
               "borderColor": "black",
               "size": {
                 "width": 50,
                 "height": 50
               },
               "x": 65,
               "y": 15
             }
           ],
           "behavior": {
             "tick[sim.time<=1;]": [
               "copies=0"
             ]
           }
         },
         {
           "name": "Degraded Protein",
           "properties": [
             "name",
             "copies"
           ],
           "label": {
             "for": [
               "name",
               "copies"
             ],
             "color": "black",
             "placement": "internal",
             "length": 15,
             "pattern": "{1}"
           },
           "elements": [
             {
               "figure": "ellipse",
               "fillColor": "grey",
               "borderColor": "black",
               "size": {
                 "width": 50,
                 "height": 50
               },
               "x": 65,
               "y": 15
             }
           ],
           "behavior": {
             "tick[sim.time<=1;]": [
               "copies=0"
             ]
           }
         }
        ],
        "linkShapes": [
         {
            "name": "Inhibits",
            "properties": [],
            "color": "red",
            "style": "dash"
          },
          {
            "name": "Stimulates",
            "properties": [],
            "color": "red",
            "style": "solid",
            "width": 1
          },
          {
            "name": "Produces",
            "properties": [
              "rate",
              "expired"
            ],
            "color": "black",
            "style": "solid",
            "label": {
              "for": [
                "rate"
              ],
              "placement": "external",
              "pattern": "{0}/s",
              "color": "black"
            },
            "width": 1,
            "behavior": {
              "tick": [
                "expired+=sim.step"
              ],
              "tick[10*${expired}*${rate}*${source().copies} >= 1;]": [
                "expired=0",
                "target().copies+=Math.floor(10*${expired}*${source().copies}*${rate});"
              ]
            }
          }, 
          {
            "name": "Consumes",
            "properties": [],
            "color": "black",
            "style": "dash",
            "width": 1
          }, {
            "name": "Degrades",
            "properties": [
              "rate",
              "expired"
            ],
            "color": "red",
            "style": "dash",
            "label": {
              "for": [
                "rate"
              ],
              "placement": "external",
              "pattern": "{0}/s",
              "color": "black"
            },
            "width": 1,
            "behavior": {
              "tick": [
                "expired+=sim.step"
              ],
              "tick[10*${expired}*${rate}*${source().copies} >= 1;]": [
                "expired=0",
                "source().copies-=Math.floor(10*${expired}*${source().copies}*${rate});",
                "target().copies+=Math.floor(10*${expired}*${source().copies}*${rate});"
              ]
            }
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
    