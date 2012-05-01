
/*
  @depend tools/toolbox.js
  @depend renderers/canvas_renderer.js
*/


(function() {

  window.onload = function() {
    paper.setup($('canvas')[0]);
    new grumble.Toolbox().install();
    new grumble.CanvasRenderer().install();
    return paper.view.draw();
  };

}).call(this);
