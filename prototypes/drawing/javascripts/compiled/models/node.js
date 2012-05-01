
/*
  @depend element.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  grumble.Node = (function(_super) {

    __extends(Node, _super);

    Node.name = 'Node';

    Node.configure("Node", "linkIds", "shape", "position", "fillColor", "strokeColor", "strokeStyle");

    Node.extend(Spine.Model.Local);

    function Node(attributes) {
      this.links = __bind(this.links, this);

      this.destroyLinks = __bind(this.destroyLinks, this);

      this.addLink = __bind(this.addLink, this);

      var k, v;
      Node.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.linkIds || (this.linkIds = []);
      this.bind("destroy", this.destroyLinks);
    }

    Node.prototype.addLink = function(id) {
      if (__indexOf.call(this.linkIds, id) < 0) {
        this.linkIds.push(id);
      }
      return this.save();
    };

    Node.prototype.removeLink = function(id) {
      return this.linkIds.remove(id);
    };

    Node.prototype.destroyLinks = function() {
      var id, _i, _len, _ref, _results;
      _ref = this.linkIds;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        _results.push(grumble.Link.destroy(id));
      }
      return _results;
    };

    Node.prototype.links = function() {
      var id, _i, _len, _ref, _results;
      _ref = this.linkIds;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        _results.push(grumble.Link.find(id));
      }
      return _results;
    };

    return Node;

  })(Spine.Model);

}).call(this);
