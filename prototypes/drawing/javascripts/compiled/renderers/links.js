
/*
  @depend ../namespace.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.LinkRenderer = (function() {

    LinkRenderer.name = 'LinkRenderer';

    LinkRenderer.prototype.item = null;

    LinkRenderer.prototype.el = null;

    function LinkRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    LinkRenderer.prototype.render = function() {
      var s, segments;
      console.log("rendering " + this.item);
      console.log("there are now " + grumble.Link.count() + " links");
      console.log(this.item);
      segments = (function() {
        var _i, _len, _ref, _results;
        _ref = this.item.segments;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
          _results.push(new paper.Segment(s.point, s.handleIn, s.handleOut));
        }
        return _results;
      }).call(this);
      this.el = new paper.Path(segments);
      this.el.spine_id = this.item.id;
      this.el.strokeColor = this.item.strokeColor;
      this.el.dashArray = this.item.strokeStyle === 'solid' ? [10, 0] : [10, 4];
      this.el.layer.insertChild(0, this.el);
      return paper.view.draw();
    };

    LinkRenderer.prototype.remove = function(node) {
      return this.el.remove();
    };

    return LinkRenderer;

  })();

}).call(this);
