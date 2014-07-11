define [
  'paper'
  'viewmodels/drawings/stencils/stencil'
  'viewmodels/drawings/stencils/stencil_specification'
  'models/property_set'
], (paper, Stencil, StencilSpecification, PropertySet) ->

  describe 'Stencil', ->    
    describe 'value', ->
      it 'returns undefined for unknown user-defined property', ->
        stencil = new TestStencil
        expect(stencil._value('fillColor')).toBeUndefined()
    
    describe 'defaultValue', ->
      it 'returns undefined for unknown default property', ->
        stencil = new TestStencil
        expect(stencil._defaultValue('fillColor')).toBeUndefined()

      it 'returns undefined for unknown default property even if it is user-defined', ->
        stencil = new TestStencil({}, fillColor: 'blue')
        expect(stencil._defaultValue('fillColor')).toBeUndefined()
    
    describe 'on construction', ->        
      it 'overrides defaults with user-defined property values', ->
        defaults  = { fillColor : 'red' }
        userDefined = { fillColor: 'blue' }
        stencil = new TestStencil(defaults, userDefined)
        
        expect(stencil._value('fillColor')).toBe('blue')
    
      it 'preserves defaults with no overriding user-defined property value', ->
        defaults  = { borderColor : 'black' }
        userDefined = { fillColor: 'blue' }
        stencil = new TestStencil(defaults, userDefined)
      
        expect(stencil._value('borderColor')).toBe('black')
        expect(stencil._value('fillColor')).toBe('blue')
        
    describe '_resolve', ->
      beforeEach ->
        @properties = jasmine.createSpyObj('propertySet', ['resolve'])
        
        element =
          properties: @properties
        
        @defaults = { width: 50, height: 100 }
        @userDefined = { width: '${saturation*5}' }
        stencil = new TestStencil(@defaults, @userDefined)
        
        @resolve = (property) =>
          stencil._resolve(element, property)
      
      it 'delegates resolution of user-defined properties to property set, passing correct default value', ->
        @resolve('width')
        expect(@properties.resolve).toHaveBeenCalledWith(@userDefined.width, @defaults.width)
    
      it 'uses the default value when a property remains undefined at resolution time', ->
        @resolve('height')
        expect(@properties.resolve).toHaveBeenCalledWith(@defaults.height, @defaults.height)

      it 'passes undefined for unknown properties', ->
        @resolve('tremendousness')
        expect(@properties.resolve).toHaveBeenCalledWith(undefined, undefined)

    

    class TestStencil extends Stencil
      constructor: (@defaults, userDefined = {}) ->
        super(userDefined)
      
      defaultSpecification: =>
        new StencilSpecification(@defaults)
    