require = window.require

describe 'ExpressionEvaluator', ->
  ExpressionEvaluator = require('models/helper/expression_evaluator')
  PaletteSpecification = require('models/palette_specification')
  Node = require('models/node')
  beforeEach ->
    @evaluator = new ExpressionEvaluator
    @palette = PaletteSpecification.create(json: '{
      "nodeShapes" : [
        {
          "name" : "Singleton", "properties": ["name"],
          "elements" : [
            {
              "figure" : "rounded",
              "size" : { "width" : 100, "height" : 50 }
            }
          ]
        },
        {
          "name" : "multie",
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

  it 'checks that a property is actually contained by its shape', ->
    params = {
        shape: @palette.nodeShapes().all()[0].id
    }
    node = new Node(params)

    expect(node.hasPropertyValue('name')).toEqual(true)

  it 'checks that a non-existent property is actually not contained by its shape', ->
    params = {
        shape: @palette.nodeShapes().all()[0].id
    }
    node = new Node(params)

    propertyValue = 'OneTooMany'
    #node.setPropertyValue('someNon', propertyValue)
    expect(node.hasPropertyValue('someNoneExistentPropertyName__')).toEqual(false)

  it 'can evaluate a simple property, implicitly on itself', ->
    params = {
        shape: @palette.nodeShapes().all()[0].id
    }
    node = new Node(params)

    result = @evaluator.getProperty('name', node) 
    expect(result.target).toEqual([node])
    expect(result.propertyName).toEqual('name')

  it 'can evaluate a simple property, explicitly on itself', ->
    params = {
        shape: @palette.nodeShapes().all()[0].id
    }
    node = new Node(params)

    result = @evaluator.getProperty('self.name', node) 
    expect(result.target).toEqual([node])
    expect(result.propertyName).toEqual('name')

  it 'can get an element that explicitly refers to self', ->
    params = {
        shape: @palette.nodeShapes().all()[0].id
    }
    node = new Node(params)

    result = @evaluator.getElements('self', node) 
    expect(result).toEqual([node])

  it 'can evaluate ', ->


  it 'expects a proper Link or Node as its context', ->
    dummyContext = {}
    expect(=> @evaluator.getProperty('name', dummyContext)).toThrow('Element is not of type Node or Link and cannot contain a Property')

  it '', ->
