
/*
  @depend element.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.Node = (function(_super) {

    __extends(Node, _super);

    Node.name = 'Node';

    Node.configure("Node", "link_ids", "shape", "position", "fillColor", "strokeColor", "strokeStyle");

    Node.extend(Spine.Model.Local);

    function Node(attributes) {
      this.destroyLinks = __bind(this.destroyLinks, this);

      this.addLink = __bind(this.addLink, this);

      var k, v;
      Node.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.link_ids = [];
      this.bind("destroy", this.destroyLinks);
    }

    Node.prototype.addLink = function(id) {
      return this.link_ids.push(id);
    };

    Node.prototype.destroyLinks = function() {
      var id, _i, _len, _ref, _results;
      _ref = this.link_ids;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        _results.push(grumble.Link.destroy(id));
      }
      return _results;
    };

    return Node;

  })(Spine.Model);

}).call(this);
