
/*
  @depend tool.js
  @depend ../models/node.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.SelectTool = (function(_super) {

    __extends(SelectTool, _super);

    SelectTool.name = 'SelectTool';

    function SelectTool() {
      return SelectTool.__super__.constructor.apply(this, arguments);
    }

    SelectTool.prototype.parameters = {};

    SelectTool.prototype.origin = null;

    SelectTool.prototype.destination = null;

    SelectTool.prototype.onMouseDown = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult) {
        hitResult.item.selected = true;
        return this.origin = hitResult.item.position;
      }
    };

    SelectTool.prototype.onMouseDrag = function(event) {
      var item;
      item = paper.project.selectedItems[0];
      if (item && item.closed) {
        return item.position = event.point;
      }
    };

    SelectTool.prototype.onMouseUp = function(event) {
      var item, link, node, _i, _len, _ref;
      item = paper.project.selectedItems[0];
      if (item && item.closed) {
        this.destination = event.point;
        node = grumble.Node.find(item.spine_id);
        node.position = this.destination;
        _ref = node.links();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          link = _ref[_i];
          this.reconnect(link, node);
        }
        return node.save();
      }
    };

    SelectTool.prototype.reconnect = function(link, node) {
      var el, offset, s;
      el = this.elementFor(link);
      console.log("Reconnecting " + link + " to " + node);
      console.log("Using " + el);
      if (link.sourceId === node.id) {
        offset = el.firstSegment.point.subtract(this.origin);
        el.removeSegment(0);
        el.insert(0, this.destination.add(offset));
      }
      if (link.targetId === node.id) {
        offset = el.lastSegment.point.subtract(this.origin);
        el.removeSegment(link.segments.size - 1);
        el.add(this.destination.add(offset));
      }
      el.simplify(100);
      link.segments = (function() {
        var _i, _len, _ref, _results;
        _ref = el.segments;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
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
      return link.save();
    };

    SelectTool.prototype.elementFor = function(link) {
      var el, matches;
      matches = (function() {
        var _i, _len, _ref, _results;
        _ref = paper.project.activeLayer.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          el = _ref[_i];
          if (el.spine_id === link.id && !el.closed) {
            _results.push(el);
          }
        }
        return _results;
      })();
      return matches[0];
    };

    return SelectTool;

  })(grumble.Tool);

}).call(this);
