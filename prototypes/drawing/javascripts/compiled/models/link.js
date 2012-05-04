
/*
  @depend ../namespace.js
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

      this.removePossibleCyclesFromSegments = __bind(this.removePossibleCyclesFromSegments, this);

      this.updateSegments = __bind(this.updateSegments, this);

      var k, v;
      Link.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this.k = v;
      }
      this.updateSegments(attributes.segments);
      this.bind("save", this.addToNodes);
      this.bind("destroy", this.removeFromNodes);
    }

    Link.prototype.updateSegments = function(segments) {
      return this.removePossibleCyclesFromSegments(segments);
    };

    Link.prototype.removePossibleCyclesFromSegments = function(segments) {
      var s;
      return this.segments = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = segments.length; _i < _len; _i++) {
          s = segments[_i];
          _results.push({
            point: {
              x: s.point.x,
              y: s.point.y
            },
            handleIn: {
              x: s.handleIn.x,
              y: s.handleIn.y
            },
            handleOut: {
              x: s.handleOut.x,
              y: s.handleOut.y
            }
          });
        }
        return _results;
      })();
    };

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
