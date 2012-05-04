
/*
  @depend ../namespace.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.Tool = (function(_super) {

    __extends(Tool, _super);

    Tool.name = 'Tool';

    function Tool() {
      return Tool.__super__.constructor.apply(this, arguments);
    }

    Tool.prototype.onKeyDown = function(event) {
      var selection;
      if (event.key === 'delete') {
        selection = paper.project.selectedItems[0];
        if (selection) {
          if (selection.closed) {
            return grumble.Node.destroy(selection.spine_id);
          } else {
            return grumble.Link.destroy(selection.spine_id);
          }
        }
      }
    };

    Tool.prototype.filterPath = function(path) {
      var s, _i, _len, _ref, _results;
      _ref = path.segments;
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
    };

    Tool.prototype.changeSelectionTo = function(item) {
      this.clearSelection();
      return this.select(item);
    };

    Tool.prototype.clearSelection = function() {
      return paper.project.activeLayer.selected = false;
    };

    Tool.prototype.select = function(item) {
      return item.selected = true;
    };

    return Tool;

  })(paper.Tool);

}).call(this);
