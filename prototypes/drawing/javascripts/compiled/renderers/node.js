
/*
  @depend ../namespace.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.NodesRenderer = (function() {

    NodesRenderer.name = 'NodesRenderer';

    function NodesRenderer() {
      this.addAllLinks = __bind(this.addAllLinks, this);

      this.addAllNodes = __bind(this.addAllNodes, this);

      this.addOne = __bind(this.addOne, this);
      grumble.Node.bind("refresh", this.addAllNodes);
      grumble.Link.bind("refresh", this.addAllLinks);
      grumble.Node.bind("create", this.addOne);
      grumble.Link.bind("create", this.addOne);
      grumble.Node.fetch();
      grumble.Link.fetch();
    }

    NodesRenderer.prototype.addOne = function(element) {
      console.log("one element added");
      return new grumble.NodeRenderer(element).render();
    };

    NodesRenderer.prototype.addAllNodes = function() {
      console.log("adding all " + grumble.Node.count() + " nodes");
      return grumble.Node.each(this.addOne);
    };

    NodesRenderer.prototype.addAllLinks = function() {
      console.log("adding all " + grumble.Link.count() + " links");
      return grumble.Link.each(this.addOne);
    };

    return NodesRenderer;

  })();

  grumble.NodeRenderer = (function() {

    NodeRenderer.name = 'NodeRenderer';

    NodeRenderer.prototype.item = null;

    NodeRenderer.prototype.el = null;

    function NodeRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.renderLink = __bind(this.renderLink, this);

      this.renderNode = __bind(this.renderNode, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    NodeRenderer.prototype.render = function() {
      console.log("rendering " + this.item);
      if (this.item instanceof grumble.Node) {
        return this.renderNode();
      } else {
        return this.renderLink();
      }
    };

    NodeRenderer.prototype.renderNode = function() {
      switch (this.item.shape) {
        case "rectangle":
          this.el = new paper.Path.Rectangle(this.item.position, new paper.Size(100, 50));
          break;
        case "circle":
          this.el = new paper.Path.Circle(this.item.position, 50);
          break;
        case "star":
          this.el = new paper.Path.Star(this.item.position, 5, 20, 50);
      }
      this.el.links = [];
      this.el.spine_id = this.item.id;
      this.el.fillColor = this.item.fillColor;
      this.el.strokeColor = this.item.strokeColor;
      return this.el.dashArray = this.item.strokeStyle === 'solid' ? [10, 0] : [10, 4];
    };

    NodeRenderer.prototype.renderLink = function() {
      var s, segments;
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

    NodeRenderer.prototype.remove = function(node) {
      return this.el.remove();
    };

    return NodeRenderer;

  })();

}).call(this);
