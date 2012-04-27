
/*
  @depend tool.js
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
      var item, link, _i, _len, _ref, _results;
      item = paper.project.selectedItems[0];
      if (item && item.links) {
        _ref = item.links;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          link = _ref[_i];
          _results.push(this.reconnect(link, item));
        }
        return _results;
      }
    };

    SelectTool.prototype.reconnect = function(link, item) {
      var offset;
      if (link.source === item) {
        offset = link.firstSegment.point.subtract(this.origin);
        link.removeSegment(0);
        link.insert(0, item.position.add(offset));
      }
      if (link.target === item) {
        offset = link.lastSegment.point.subtract(this.origin);
        link.removeSegment(link.segments.size - 1);
        link.add(item.position.add(offset));
      }
      return link.simplify(100);
    };

    return SelectTool;

  })(grumble.Tool);

}).call(this);
