exports.config = config =
  # See http://brunch.readthedocs.org/en/latest/config.html for documentation.

  serverUrl: "http://logroll.in"

  environment: ""

  modules:
    wrapper: false
    definition: false

  paths:
    watched: ['src', 'test']
    public: 'build'

  files:
    javascripts:
      joinTo:
        'LogAndRollSDK.js': (path) ->

          env = config.environment
          if env is "browser"
            return /^src/.test(path) and path.indexOf("/Node/") == -1

          if env is "node"
            return /^src/.test(path) and path.indexOf("/Browser/") == -1

        'test.js': /^test/
      order:
        before: [
          'src/Header.coffee'
          'src/BaseEngine.coffee'

          /ˆLibraries/

          'src/StorageEngines/StorageEngine.coffee'
          'src/SendEngines/SendEngine.coffee'

          /ˆsrc\/StorageEngines/
          /ˆsrc\/SendEngines/
        ]
        after: [
          'src/Main.coffee'
        ]

  overrides:
    node:
      environment: "node"
      plugins:
        singlewrap:
          wrap: (file, code) ->
            return "(function(window,serverUrl){\n#{code}\n})(global,'#{config.serverUrl}');"

    browser:
      environment: "browser"
      plugins:
        singlewrap:
          wrap: (file, code) ->
            return "(function(window,serverUrl){\n#{code}\n})(window,'#{config.serverUrl}');"

  plugins:

    uglify:
      mangle: yes
      compress:
        global_defs:
          DEBUG: false

    coffeescript:
      bare: true

  minify: true