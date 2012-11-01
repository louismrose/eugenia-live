require = window.require

describe 'EugeniaNotation', ->
  EugeniaNotation = require('controllers/notations/eugenia_notation')
  NodeShape = require('models/node_shape')
  LinkShape = require('models/link_shape')

  beforeEach ->
    @notation = new EugeniaNotation

  it 'can represent a minimal nodeshape', ->
    shape = new NodeShape
      name: "Simple"
      elements: [
        figure: "rectangle"
      ]
    
    expect(@notation.reconstruct(shape)).toEqual(shape.toJSON())
  
  
  it 'can represent additional properties of each element', ->
    shape = new NodeShape
      name: "Simple"
      elements: [
        figure: "rectangle"
        borderColor: "rgba(255, 0, 0, 1)"
        fillColor: "rgba(255, 0, 0, 1)"
        size: { width: 10, height: 40 }
      ]

    expect(@notation.reconstruct(shape)).toEqual(shape.toJSON())
  
  
  it 'can represent only the first element of a multielement node shape', ->
    shape = new NodeShape
      name: "Simple"
      elements: [
        {
          figure: "rectangle"
          borderColor: "rgba(255, 0, 0, 1)"
          fillColor: "rgba(0, 255, 0, 1)"
          size: { width: 10, height: 40 }
        },
        {
          figure: "circle"
          borderColor: "rgba(0, 0, 255, 1)"
          fillColor: "rgba(255, 255, 0, 1)"
          size: { width: 5, height: 5 }
        }
      ]

    expected = shape.toJSON()
    expected.elements = [expected.elements[0]]

    expect(@notation.reconstruct(shape)).toEqual(expected)

  
  it 'can represent a minimal labelled nodeshape', ->
    shape = new NodeShape
      name: "Simple"
      label: 
        for: ["name"]
        pattern: "{0}"

    expect(@notation.reconstruct(shape)).toEqual(shape.toJSON())
  
    
  it 'can represent additional properties of a labelled nodeshape', ->
    shape = new NodeShape
      name: "Simple"
      label: 
        for: ["name", "state"]
        pattern: "{1} --> {0}"
        placement: "external"
        color: "rgba(128, 0, 128, 1)"
        length: 20

    expect(@notation.reconstruct(shape)).toEqual(shape.toJSON())
   
    
  it 'can represent a minimal linkshape', ->
    shape = new LinkShape
      name: "Simple"
      color: "rgba(0, 0, 0, 1)" 
      style: "solid"

    expect(@notation.reconstruct(shape)).toEqual(shape.toJSON())