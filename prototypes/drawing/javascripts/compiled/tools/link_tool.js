
/*
  @depend tool.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.LinkTool = (function(_super) {

    __extends(LinkTool, _super);

    LinkTool.name = 'LinkTool';

    function LinkTool() {
      return LinkTool.__super__.constructor.apply(this, arguments);
    }

    LinkTool.prototype.parameters = {};

    LinkTool.prototype.currentLink = null;

    LinkTool.prototype.linkLayer = null;

    LinkTool.prototype.onMouseMove = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult) {
        return hitResult.item.selected = true;
      }
    };

    LinkTool.prototype.onMouseDrag = function(event) {
      var hitResult;
      if (!this.currentLink) {
        this.linkLayer = new paper.Layer();
        this.currentLink = new paper.Path([event.point]);
        this.currentLink.strokeColor = 'black';
      }
      this.currentLink.add(event.point);
      hitResult = paper.project.layers[0].hitTest(event.point);
      if (hitResult) {
        paper.project.layers[0].selected = false;
        return hitResult.item.selected = true;
      }
    };

    LinkTool.prototype.onMouseUp = function(event) {
      var hitResult;
      if (this.currentLink) {
        this.currentLink.simplify();
        paper.project.layers[0].activate();
        hitResult = paper.project.activeLayer.hitTest(event.point);
        if (hitResult) {
          paper.project.activeLayer.insertChild(0, this.currentLink);
        }
        paper.project.activeLayer.selected = false;
        this.linkLayer.remove();
        this.currentLink = null;
        return this.linkLayer = null;
      }
    };

    return LinkTool;

  })(grumble.Tool);

}).call(this);
