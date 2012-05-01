
/*
  @depend ../namespace.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.NodeRenderer = (function() {

    NodeRenderer.name = 'NodeRenderer';

    function NodeRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    NodeRenderer.prototype.render = function() {
      console.log("rendering " + this.item);
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

    NodeRenderer.prototype.remove = function(node) {
      return this.el.remove();
    };

    return NodeRenderer;

  })();

}).call(this);
