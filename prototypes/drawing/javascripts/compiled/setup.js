
/*
  @depend tools/toolbox.js
  @depend models/node.js
*/


(function() {

  window.onload = function() {
    paper.setup($('canvas')[0]);
    new grumble.Toolbox().install();
    new grumble.NodesRenderer;
    return paper.view.draw();
  };

}).call(this);
