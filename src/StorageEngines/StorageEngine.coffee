class StorageEngine extends BaseEngine

  @saveDebounce: 500
  @prefix: "LogNRoll-"
  @blobPrefix: "#{StorageEngine.prefix}blob-"
  @deviceIDKey: "#{StorageEngine.prefix}deviceID"
  @engines: []
  @supportedEngines: []
  @error:
    full: 0

  @isValidBlobName: (name) ->
    return name.indexOf(@blobPrefix) == 0
  @blobName: ->
    return @blobPrefix + ts()

  deviceId: ->
    throw implementError()

  nextBlob: (callback) ->
    throw implementError()

  appendBlob: (blob, callback) ->
    throw implementError()

  deleteBlob: (blob) ->
    throw implementError()