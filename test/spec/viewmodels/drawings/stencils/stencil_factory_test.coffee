define [
  'viewmodels/drawings/stencils/stencil_factory'
], (StencilFactory) ->

  describe 'StencilFactory', ->
    describe 'convertLinkShape', ->
      describe 'plain link shapes', ->
        it 'creates a path stencil', ->    
          stencil = createStencilFromLinkShape({})
          expect(stencil.constructor.name).toEqual("PathStencil")
      
        it 'propagates properties of shape to path stencil', ->
          shape =
            color: "blue"
            style: "dash"
      
          stencil = createStencilFromLinkShape(shape)
    
          expect(stencil._specification.get("color")).toEqual("blue")
          expect(stencil._specification.get("style")).toEqual("dash")
      
      describe 'labelled link shapes', ->
        it 'creates a labelled stencil', ->
          shape =
            label:
              placement: "internal"
              text : "${name}"
              color : "green"
              length : 8
 
          stencil = createStencilFromLinkShape(shape)

          expect(stencil._specification.get("placement")).toEqual("internal")
          expect(stencil._specification.get("text")).toEqual("${name}")
          expect(stencil._specification.get("color")).toEqual("green")
          expect(stencil._specification.get("length")).toEqual(8)

        it 'passes original stencil to labelled stencil', ->
          shape =
            label:
              placement: "internal"
 
          stencil = createStencilFromLinkShape(shape)

          expect(stencil.constructor.name).toEqual("LabelStencil")
          expect(stencil._labelled.constructor.name).toEqual("PathStencil")
      
      createStencilFromLinkShape = (shape) ->  
        new StencilFactory().convertLinkShape(shape)
    
    describe 'convertNodeShape', ->
      describe 'single-element shapes', ->
        it 'creates a rectangle stencil for rectangle figure', ->    
          stencil = createStencilFromNodeShape(singleElementShape("rectangle"))
          expect(stencil.constructor.name).toEqual("RectangleStencil")
    
        it 'creates a rounded rectangle stencil for rounded rectangle figure', ->
          stencil = createStencilFromNodeShape(singleElementShape("rounded"))
          expect(stencil.constructor.name).toEqual("RoundedRectangleStencil")

        it 'creates an ellipse stencil for ellipse figure', ->
          stencil = createStencilFromNodeShape(singleElementShape("ellipse"))
          expect(stencil.constructor.name).toEqual("EllipseStencil")

        it 'creates a regular polygon stencil for polygon figure', ->
          stencil = createStencilFromNodeShape(singleElementShape("polygon"))
          expect(stencil.constructor.name).toEqual("RegularPolygonStencil")
    
        it 'throws an error for unknown figure', ->
          expect(=> createStencilFromNodeShape(singleElementShape("cube"))).toThrow()
    
        it 'propagates properties of shape to stencil', ->
          shape =
            elements: [
              figure: "rounded"
              size: { width: 200, height: 300 }
              fillColor: "blue"
              borderColor: "red"
            ]
        
          stencil = createStencilFromNodeShape(shape)
      
          expect(stencil._specification.get("size.width")).toEqual(200)
          expect(stencil._specification.get("size.height")).toEqual(300)
          expect(stencil._specification.get("fillColor")).toEqual("blue")
          expect(stencil._specification.get("borderColor")).toEqual("red")
      
        singleElementShape = (figureType) ->
          shape =
            elements: [
              figure: figureType
            ]

      describe 'multi-element shapes', ->
        it 'creates a composite stencil', ->
          shape =
            elements: [
              { figure: "rounded" },
              { figure: "ellipse" },
              { figure: "rounded" },
              { figure: "rectangle" }
            ]
 
          stencil = createStencilFromNodeShape(shape)

          expect(stencil.constructor.name).toEqual("CompositeStencil")
          expect(stencil._stencils.length).toEqual(4)
          expect(stencil._stencils[0].constructor.name).toEqual("RoundedRectangleStencil")
          expect(stencil._stencils[1].constructor.name).toEqual("EllipseStencil")
          expect(stencil._stencils[2].constructor.name).toEqual("RoundedRectangleStencil")
          expect(stencil._stencils[3].constructor.name).toEqual("RectangleStencil")
    

      describe 'labelled shapes', ->
        it 'creates a labelled stencil', ->
          shape =
            elements: [ figure: "rounded" ]
            label:
              placement: "internal"
              text : "${name}"
              color : "green"
              length : 8
 
          stencil = createStencilFromNodeShape(shape)

          expect(stencil._specification.get("placement")).toEqual("internal")
          expect(stencil._specification.get("text")).toEqual("${name}")
          expect(stencil._specification.get("color")).toEqual("green")
          expect(stencil._specification.get("length")).toEqual(8)

        it 'passes original stencil to labelled stencil', ->
          shape =
            elements: [ figure: "rounded" ]
            label:
              placement: "internal"
 
          stencil = createStencilFromNodeShape(shape)

          expect(stencil.constructor.name).toEqual("LabelStencil")
          expect(stencil._labelled.constructor.name).toEqual("RoundedRectangleStencil")

      createStencilFromNodeShape = (shape) ->  
        new StencilFactory().convertNodeShape(shape)