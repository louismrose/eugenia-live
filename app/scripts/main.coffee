require.config
  paths:
    jquery: "../bower_components/jquery/jquery"
    bootstrap: "../bower_components/bootstrap.css/js/bootstrap"
    paper: "../bower_components/paper/dist/paper-core"
    bacon: "../bower_components/bacon/dist/Bacon"
    codemirror: "../bower_components/codemirror/lib/codemirror"
    codemirror_js: "../bower_components/codemirror/mode/javascript/javascript"
    codemirror_lint: "../bower_components/codemirror/addon/lint/lint"
    codemirror_json_lint: "../bower_components/codemirror/addon/lint/json-lint"
    jsonlint: "../bower_components/jsonlint/lib/jsonlint"
    spine: "../bower_components/spine/lib/spine"
    spine_manager: "../bower_components/spine/lib/manager"
    spine_relation: "../bower_components/spine/lib/relation"
    spine_route: "../bower_components/spine/lib/route"

  shim:
    bootstrap:
      deps: ["jquery"]
      exports: "jquery"

    codemirror:
      exports: "CodeMirror"

    codemirror_js:
      deps: ["codemirror"]

    codemirror_lint:
      deps: ["codemirror"]

    codemirror_json_lint:
      deps: ["codemirror", "codemirror_lint", "jsonlint"]

    jsonlint:
      exports: "jsonlint"
    
    spine:
      exports: "Spine"

    spine_manager:
      deps: ["spine"]
    
    spine_relation:
      deps: ["spine"]
    
    spine_route:
      deps: ["spine"]
    
    bacon:
      deps: ["jquery"]

require ["app", "jquery"], (App, $) ->
  new App(el: $('body'))
