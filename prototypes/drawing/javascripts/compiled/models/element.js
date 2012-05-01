
/*
  @depend ../namespace.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.Element = (function(_super) {

    __extends(Element, _super);

    Element.name = 'Element';

    function Element() {
      return Element.__super__.constructor.apply(this, arguments);
    }

    Element.extend(Spine.Model.Local);

    return Element;

  })(Spine.Model);

}).call(this);
