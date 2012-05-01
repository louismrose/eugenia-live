
/*
  @depend element.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.Link = (function(_super) {

    __extends(Link, _super);

    Link.name = 'Link';

    Link.configure("Link", "sourceId", "targetId", "segments", "strokeColor", "strokeStyle");

    Link.extend(Spine.Model.Local);

    function Link(attributes) {
      this.target = __bind(this.target, this);

      this.source = __bind(this.source, this);

      this.removeFromNodes = __bind(this.removeFromNodes, this);

      this.addToNodes = __bind(this.addToNodes, this);

      var k, v;
      Link.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.bind("save", this.addToNodes);
      this.bind("destroy", this.removeFromNodes);
    }

    Link.prototype.addToNodes = function() {
      this.source().addLink(this.id);
      return this.target().addLink(this.id);
    };

    Link.prototype.removeFromNodes = function() {
      if (grumble.Node.exists(this.sourceId)) {
        this.source().removeLink(this.id);
      }
      if (grumble.Node.exists(this.targetId)) {
        return this.target().removeLink(this.id);
      }
    };

    Link.prototype.source = function() {
      return grumble.Node.find(this.sourceId);
    };

    Link.prototype.target = function() {
      return grumble.Node.find(this.targetId);
    };

    return Link;

  })(Spine.Model);

}).call(this);
