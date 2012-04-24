
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

    SelectTool.prototype.onMouseDown = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult) {
        return hitResult.item.selected = true;
      }
    };

    SelectTool.prototype.onMouseDrag = function(event) {
      if (paper.project.selectedItems[0]) {
        return paper.project.selectedItems[0].position = event.point;
      }
    };

    return SelectTool;

  })(grumble.Tool);

}).call(this);
