
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
      var copy, item, link, _i, _len, _ref, _results;
      if (event.key === 'delete') {
        item = paper.project.selectedItems[0];
        if (item) {
          item.remove();
          if (item.links) {
            _ref = item.links;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              link = _ref[_i];
              _results.push(link.remove());
            }
            return _results;
          }
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

    return Tool;

  })(paper.Tool);

}).call(this);
