require = window.require

describe 'PaletteSpecification', ->
  PaletteSpecification = require('models/palette_specification')

  beforeEach ->
    @palette = PaletteSpecification.create(json: '{
      "nodeShapes" : [
        {
          "name" : "singleton",
          "elements" : [
            {
              "figure" : "rounded",
              "size" : { "width" : 100, "height" : 50 }
            }
          ]
        },
        {
          "name" : "multi",
          "elements" : [
            {
              "figure": "ellipse"
            },
            {
              "figure": "square"
            }
          ]
        }
      ],
      "linkShapes" : [
        {
          "name": "transition",
          "color": "black"
        }
      ]
    }').instantiate()

  it 'creates node shapes from JSON', ->
    expect(@palette.nodeShapes().all().length).toBe(2)
    
  it 'names first node shape from JSON', ->
    expect(@palette.nodeShapes().all()[0].name).toBe("singleton")

  it 'creates elements for first node shape from JSON', ->
    elements = @palette.nodeShapes().all()[0].elements
    expect(elements.length).toBe(1)
    expect(elements[0].figure).toBe("rounded")
    expect(elements[0].size.width).toBe(100)
    expect(elements[0].size.height).toBe(50)
  
  it 'names second node shape from JSON', ->
    expect(@palette.nodeShapes().all()[1].name).toBe("multi")
    
  it 'creates elements for second node shape from JSON', ->
    elements = @palette.nodeShapes().all()[1].elements
    expect(elements.length).toBe(2)
    expect(elements[0].figure).toBe("ellipse")
    expect(elements[1].figure).toBe("square")
  
  it 'creates links shapes from JSON', ->
    expect(@palette.linkShapes().all().length).toBe(1)
  
  it 'creates values for first link shapes from JSON', ->
    linkShape = @palette.linkShapes().all()[0]
    expect(linkShape.name).toBe("transition")
    expect(linkShape.color).toBe("black")
  