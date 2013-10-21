define [
  'viewmodels/drawings/rectangle'
  'viewmodels/drawings/rounded_rectangle'
  'viewmodels/drawings/ellipse'
  'viewmodels/drawings/polygon'
], (Rectangle, RoundedRectangle, Ellipse, Polygon) ->

  class ElementFactory
    types:
      rectangle: Rectangle
      rounded: RoundedRectangle
      ellipse: Ellipse
      polygon: Polygon
      
    elementFor: (element) =>
      type = @types[element.figure]
      throw new Error("#{element.figure} is not a valid type of element") unless type
      new type(element)