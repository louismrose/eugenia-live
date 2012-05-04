
/*
  @depend tool.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.LinkTool = (function(_super) {
    var DraftLink;

    __extends(LinkTool, _super);

    LinkTool.name = 'LinkTool';

    function LinkTool() {
      return LinkTool.__super__.constructor.apply(this, arguments);
    }

    LinkTool.prototype.parameters = {
      'strokeColor': 'black',
      'strokeStyle': 'solid'
    };

    LinkTool.prototype.draftLink = null;

    LinkTool.prototype.drafting = false;

    LinkTool.prototype.onMouseMove = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      this.clearSelection();
      if (hitResult && hitResult.item.closed) {
        return this.select(hitResult.item);
      }
    };

    LinkTool.prototype.onMouseDown = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      if (hitResult) {
        this.drafting = true;
        return this.draftLink = new DraftLink(event.point);
      }
    };

    LinkTool.prototype.onMouseDrag = function(event) {
      var hitResult;
      if (this.drafting) {
        this.draftLink.extendTo(event.point);
        hitResult = paper.project.hitTest(event.point);
        if (hitResult && hitResult.item.closed) {
          return this.changeSelectionTo(hitResult.item);
        }
      }
    };

    LinkTool.prototype.onMouseUp = function(event) {
      var hitResult;
      if (this.drafting) {
        hitResult = paper.project.hitTest(event.point);
        if (hitResult && hitResult.item.closed) {
          this.draftLink.finalise(this.parameters);
        }
        this.draftLink.remove();
        this.clearSelection();
        return this.drafting = false;
      }
    };

    DraftLink = (function() {

      DraftLink.name = 'DraftLink';

      DraftLink.prototype.path = null;

      function DraftLink(origin) {
        this.path = new paper.Path([origin]);
        this.path.layer.insertChild(0, this.path);
        this.path.strokeColor = 'black';
        this.path.dashArray = [10, 4];
      }

      DraftLink.prototype.extendTo = function(point) {
        return this.path.add(point);
      };

      DraftLink.prototype.finalise = function(parameters) {
        this.path.simplify(100);
        parameters.sourceId = paper.project.hitTest(this.path.firstSegment.point).item.spine_id;
        parameters.targetId = paper.project.hitTest(this.path.lastSegment.point).item.spine_id;
        parameters.segments = this.path.segments;
        return new grumble.Link(parameters).save();
      };

      DraftLink.prototype.remove = function() {
        return this.path.remove();
      };

      return DraftLink;

    })();

    return LinkTool;

  })(grumble.Tool);

}).call(this);
