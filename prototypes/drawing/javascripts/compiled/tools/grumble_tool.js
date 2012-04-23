(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.GrumbleTool = (function(_super) {

    __extends(GrumbleTool, _super);

    GrumbleTool.name = 'GrumbleTool';

    function GrumbleTool() {
      return GrumbleTool.__super__.constructor.apply(this, arguments);
    }

    GrumbleTool.prototype.onKeyDown = function(event) {
      var copy;
      if (event.key === 'delete') {
        if (paper.project.selectedItems[0]) {
          return paper.project.selectedItems[0].remove();
        }
      } else if (event.modifiers.command && event.key === 'c') {
        return window.clipboard = paper.project.selectedItems[0];
      } else if (event.modifiers.command && event.key === 'v') {
        if (window.clipboard) {
          if (paper.project.selectedItems[0]) {
            paper.project.selectedItems[0].selected = false;
          }
          copy = window.clipboard.clone();
          copy.position.x += 10;
          copy.position.y += 10;
          copy.selected = true;
          return window.clipboard = copy;
        }
      }
    };

    return GrumbleTool;

  })(paper.Tool);

}).call(this);
