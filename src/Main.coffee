log = ->
  # To the bitbucket!
  return

class LogAndRoll

  @version: "0.5"
  @sharedInstance: null
  @launch: (attrs) ->

    return @sharedInstance if @sharedInstance != null

    @sharedInstance = new LogAndRoll(attrs)

    #create shortcut log function
    window.LogNRoll = @sharedInstance.LogNRoll if @sharedInstance != null

    return @sharedInstance

  postingBlobs: no
  postBlobs: ->
    return if postingBlobs

    postingBlobs = no

  buffer: []

  constructor: (attrs) ->

    # Check supported storage engines
    storageEngines = StorageEngine.checkSupportedEngines()
    # Do the same for send engines
    sendEngines = SendEngine.checkSupportedEngines()

    compareNice = (a, b) ->
      if a.nice > b.nice
        return -1
      else if (a.nice < b.nice)
        return 1

      return 0

    # Sort based on nice value
    sendEngines.sort(compareNice)
    storageEngines.sort(compareNice)

    if sendEngines.length == 0 or storageEngines.length == 0
      console.error "Log & Roll is not supported as no suitable engines could be found for this platform"
      return null

    # Grab the first & the best!
    @storageEngine = new storageEngines[0](@)
    @sendEngine = new sendEngines[0](@)

    defaultSettings =
      saveDebounce: @storageEngine.constructor.saveDebounce
      sendTimeout: @sendEngine.constructor.sendTimeout
      device: {}
      debug: no

    # Extend attrs with our default settings
    extend(attrs, defaultSettings)

    @device = attrs.device
    @appName = attrs.appName
    @APIKey = attrs.APIKey
    @debug = attrs.debug

    if @debug
      log = ->
        arguments_ = ['L&R >>']
        for arg in arguments
          arguments_.push arg

        console.log.apply console, arguments_

    @sendLogs = (callback = null) =>

      # Grab a blob we want to send
      @storageEngine.nextBlob((blob) =>
        if blob.logs.length > 0
          @sendEngine.sendBlob(blob, (err) =>
            hasCallback = callback?
            if err?
              callback(err) if hasCallback
            else
              @storageEngine.deleteBlob(blob)
              callback(null) if hasCallback

            sendTick()
          )
        else
          @storageEngine.deleteBlob(blob)
          sendTick()
      )

    sendTick = =>
      sendTimer = setTimeout(@sendLogs, attrs.sendTimeout)

    sendTick()

    @saveBlobs = (callback = null) =>
      # Copy the buffer length 'as is' when saving, append, remove the objects when done from the buffer
      # Only when successful!
      hasCallback = callback?
      originalBufferLength = @buffer.length

      return if originalBufferLength <= 0

      @storageEngine.appendBlob(@buffer, (error) =>
        if error?
          # Storage is full, we should try sending RIGHT NOW so we can ditch the stuff!
          @sendLogs()
          callback(error) if hasCallback
        else
          @buffer.splice(0, originalBufferLength)
          callback(null) if hasCallback
      )

    saveLogTick = debounce(@saveBlobs, attrs.saveDebounce)

    @LogNRoll = =>
      tag = arguments[0]
      message = ""

      # combine rest of arguments as message
      len = arguments.length-1
      for i in [1..len]
        message += niceIfy(arguments[i])
        message += " " if i < len

      logObj =
        tag: tag
        message: message
        timestamp: ts()

      # Queue for saving later
      @buffer.push(logObj)
      saveLogTick()

      return logObj

    log "Log & Roll JavaScript SDK v#{LogAndRoll.version}"



#Main Name Space
window.LogAndRoll = LogAndRoll