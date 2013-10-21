define [
  'paper'
  'viewmodels/drawings/stencils/stencil_specification'
], (paper, StencilSpecification) ->

  describe 'StencilSpecification', ->  
    describe 'merge', ->
      it 'preserves original value', ->
        specification = new StencilSpecification(width: 100)
        specification.merge(width: 50)
        expect(specification.get("width")).toBe(100)
      
      it 'takes value not present in specification', ->
        specification = new StencilSpecification(width: 100)
        specification.merge(height: 50)
        expect(specification.get("height")).toBe(50)
      
      it 'works on nested keys', ->
        specification = new StencilSpecification(position: { x: 5 })
        specification.merge(position: { y: 10})

        expect(specification.get("position").x).toBe(5)
        expect(specification.get("position").y).toBe(10)
      
      it 'takes entire objects when not present in specification', ->
        specification = new StencilSpecification()
        specification.merge(position: { x: 15, y: 20})

        expect(specification.get("position").x).toBe(15)
        expect(specification.get("position").y).toBe(20)
      
      it 'works on other stencil specifications', ->
        specification = new StencilSpecification()
        specification.merge(new StencilSpecification(position: { x: 15, y: 20}))

        expect(specification.get("position").x).toBe(15)
        expect(specification.get("position").y).toBe(20)
      
      
    describe 'get', ->
      it 'works on nested keys', ->
        specification = new StencilSpecification(shape: { position: { x: 5 } })
        expect(specification.get("shape.position.x")).toBe(5)

      it 'returns undefined when property not present', ->
        specification = new StencilSpecification()
        expect(specification.get("shape")).not.toBeDefined()

      it 'returns undefined when entire structure not present', ->
        specification = new StencilSpecification()
        expect(specification.get("shape.position.x")).not.toBeDefined()
      
      it 'returns undefined when last element of structure not present', ->
        specification = new StencilSpecification(shape: { position: { y: 5 } })
        expect(specification.get("shape.position.x")).not.toBeDefined()