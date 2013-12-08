class SendEngine extends BaseEngine

  @blobEndpoint: (logAndRoll) ->
    "#{serverUrl}/api/#{logAndRoll.appName}/#{logAndRoll.APIKey}/blob/#{logAndRoll.storageEngine.deviceId()}"

  @sendTimeout: 2000
  @engines: []
  @supportedEngines: []
  @error:
    sending_failed: 0

  @supported: ->
    throw implementError()

  sendBlob: (blob, callback) ->
    throw implementError()