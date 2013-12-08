class HTML5StorageEngine extends StorageEngine

  @nice: 1
  @engines.push(@)

  @supported: ->

    try
      `(('localStorage' in window) && window['localStorage'] !== null)`
    catch e
      false

  deviceId: ->
    id = Store.get(StorageEngine.deviceIDKey)
    if not id?
      id = uniqueId(15)
      Store.set(StorageEngine.deviceIDKey, id)

    return id

  # Capture blob keys for removing later
  sendingKeys: null

  deleteBlob: (blob) ->
    for key in @sendingKeys
      Store.expire(key)

  appendBlob: (blob, callback) ->
    orignalName = name = StorageEngine.blobName()
    idx = 0
    while Store.get(name)?
      name = orignalName + ++idx

    result = Store.set(name, JSON.stringify(blob))
    if result == null
      callback(StorageEngine.error.full)
    else
      callback()

  nextBlob: (callback) ->
    # we just merge the blobs we have as one
    blobs = []
    @sendingKeys = []

    for i in [0..localStorage.length-1]
      key = localStorage.key(i)

      if StorageEngine.isValidBlobName(key)
        @sendingKeys.push(key)
        blob = JSON.parse(Store.get(key))
        blobs = blobs.concat(blob)

    callback(logs: blobs)

