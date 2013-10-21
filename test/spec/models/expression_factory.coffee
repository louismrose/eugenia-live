define [
  'models/expression_factory'
  'models/literal_expression'
  'models/property_set_expression'
], (ExpressionFactory, LiteralExpression, PropertySetExpression) ->

  describe 'ExpressionFactory', ->
    it 'returns PropertySetExpression when expression is of form ${foo}', ->
      expression = new ExpressionFactory().expressionFor("${foo}")
      expect(expression instanceof PropertySetExpression).toBeTruthy()
      
    it 'returns LiteralExpression otherwise', ->
      expression = new ExpressionFactory().expressionFor("foo")
      expect(expression instanceof LiteralExpression).toBeTruthy()
