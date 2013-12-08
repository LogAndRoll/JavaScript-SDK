class BaseEngine

  constructor: (@logAndRoll) ->

  @nice: 0
  @checkSupportedEngines: ->

    @supportedEngines = []

    for engine in @engines
      @supportedEngines.push(engine) if engine.supported()

    return @supportedEngines

  @supported: ->

    # This is a base class, forcing to return no will make sure it won't get added to the supportedEngines array
    return no