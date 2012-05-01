
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

    Link.configure("Link", "segments", "strokeColor", "strokeStyle");

    Link.extend(Spine.Model.Local);

    function Link(attributes) {
      this.target = __bind(this.target, this);

      this.source = __bind(this.source, this);

      this.updateNodes = __bind(this.updateNodes, this);

      var k, v;
      Link.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.bind("save", this.updateNodes);
    }

    Link.prototype.updateNodes = function() {
      if (this.source_id) {
        this.source().addLink(this.id);
      }
      if (this.source_id !== this.target_id) {
        return this.target().addLink(this.id);
      }
    };

    Link.prototype.source = function() {
      return grumble.Node.find(this.source_id);
    };

    Link.prototype.target = function() {
      return grumble.Node.find(this.target_id);
    };

    return Link;

  })(Spine.Model);

}).call(this);
