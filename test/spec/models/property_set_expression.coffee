define [
  'models/property_set_expression'
], (PropertySetExpression) ->

  describe 'PropertySetExpression', ->
    describe "appliesFor", ->
      it "accepts strings of form ${..}", ->
        expect(PropertySetExpression.appliesFor("${color}")).toBeTruthy()

      it "rejects non-strings", ->
        expect(PropertySetExpression.appliesFor(42)).toBeFalsy()
        expect(PropertySetExpression.appliesFor(true)).toBeFalsy()
        expect(PropertySetExpression.appliesFor({})).toBeFalsy()
        expect(PropertySetExpression.appliesFor(undefined)).toBeFalsy()

      it "rejects plain strings", ->
        expect(PropertySetExpression.appliesFor("color")).toBeFalsy()
        expect(PropertySetExpression.appliesFor("")).toBeFalsy()

      it "rejects plain strings starting with $", ->
        expect(PropertySetExpression.appliesFor("$color")).toBeFalsy()

    
    describe "evaluate", ->
      it '${foo} evaluates to properties.get("foo")', ->
        properties = new FakePropertySet("red")
        expression = new PropertySetExpression("${color}", properties)
        expect(expression.evaluate()).toBe("red")
      
      it 'coerces numbers', ->
        properties = new FakePropertySet("50")
        expression = new PropertySetExpression("${width}", properties)
        expect(expression.evaluate()).toBe(50)
        
      it 'evalutes to undefined when property does not exist ', ->
        properties = new FakePropertySet(undefined)
        expression = new PropertySetExpression("${color}", properties)
        expect(expression.evaluate()).toBe(undefined)
    
    class FakePropertySet
      constructor: (@value) ->
      get: (property) ->
        @value