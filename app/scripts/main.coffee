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
    
    bacon:
      deps: ["jquery"]

require ["app", "jquery"], (App, $) ->
  new App(el: $('body'))
