### StencilSpecification
This class encapsulates logic required for accessing the properties used to 
define Stencils. As we represent properties as Coffeescript objects (which
are much like maps / dictionaries / associative arrays in other programming
languages), this class essentially provides a few small extensions that make
working with objects slightly more convenient.

    define [
    ], () ->
  
      class StencilSpecification
        constructor: (@_properties = {}) ->

Merging this specification with another results in taking all of the properties
from the other specification for which this specification does not already have
a value. For example `{ a: 1, b: 2 }.merge(b: 42, c: 3)` results in the 
original specification changing to `{ a: 1, b: 2, c: 3 }`. 
    
        merge: (mergee) =>
          mergee = mergee._properties if mergee instanceof StencilSpecification
          @_merge(@_properties, mergee)
          @

We use recursion to merge a set of properties, so that we can handle merging of
nested objects such as `{ size: { width: 100, height: 200 } }`.

        _merge: (target, mergee) =>
          for key, value of mergee
            if value instanceof Object
              target[key] or= {}
              target[key] = @_merge(target[key], value)
            else
              target[key] or= value
          target
  
Getting a value from this specification works just like the typical Coffeescript
dot operator (e.g., `properties.name`) except that we can retrieve values of
nested properties: `specification.get("size.height")`.
  
        get: (keys = "") =>
          @_get(@_properties, keys.split("."))
      
We use recursion to retrieve values for nested properties. This recursive
function must be called with an array of keys (rather than a string). First, 
we return undefined if the object from which we should a retrieve a value is 
undefined. Next, we check the base case of the recursion: if there are no keys
remaining then we return the current object. Otherwise, we take the first key 
in the array, retrieve the value of that key from the object, and attempt to 
get the value of the remaining keys from this value.
      
        _get: (object, keys = []) =>
          return undefined if object is undefined
          return object unless keys.length
      
          [key, remainingKeys...] = keys
          @_get(object[key], remainingKeys)