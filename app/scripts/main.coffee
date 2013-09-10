require.config
  paths:
    'jquery' : "../bower_components/jquery/jquery"
    'bootstrap' : "../bower_components/bootstrap.css/js/bootstrap"
    'paper' : "../bower_components/paper/dist/paper-core"
    'bacon' : "../bower_components/bacon/dist/Bacon"
    'codemirror' : "../bower_components/codemirror/lib/codemirror"
    'codemirror.javascript' : "../bower_components/codemirror/mode/javascript/javascript"
    'codemirror.lint' : "../bower_components/codemirror/addon/lint/lint"
    'codemirror.jsonlint' : "../bower_components/codemirror/addon/lint/json-lint"
    'jsonlint' : "../bower_components/jsonlint/lib/jsonlint"
    'spine': "../bower_components/spine/lib/spine"
    'spine.manager' : "../bower_components/spine/lib/manager"
    'spine.model.local' : "../bower_components/spine/lib/local"
    'spine.relation' : "../bower_components/spine/lib/relation"
    'spine.route' : "../bower_components/spine/lib/route"

  shim:
    'bootstrap':
      deps: ["jquery"]
      exports: "jquery"

    'codemirror':
      exports: "CodeMirror"

    'codemirror.javascript':
      deps: ["codemirror"]

    'codemirror.lint':
      deps: ["codemirror"]

    'codemirror.jsonlint':
      deps: ["codemirror", "codemirror.lint", "jsonlint"]

    'jsonlint':
      exports: "jsonlint"
    
    'spine':
      exports: "Spine"

    'spine.manager':
      deps: ["spine"]

    'spine.model.local':
      deps: ["spine"]
    
    'spine.relation':
      deps: ["spine"]
    
    'spine.route':
      deps: ["spine"]
    
    'bacon':
      deps: ["jquery"]

require ["app", "jquery"], (App, $) ->
  new App(el: $('div#content'))
