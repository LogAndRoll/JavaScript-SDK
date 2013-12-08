NodeFileSystemStorageEngine = null
(->
  path = fs = os = null
  class NodeFileSystemStorageEngine extends StorageEngine

    @nice: 0
    @blobName: ->
      orignalName = StorageEngine.blobName()
      name = path.join(NodeFileSystemStorageEngine.folder, orignalName) + ".json"
      idx = 0
      while fs.existsSync(name)
        name = path.join(NodeFileSystemStorageEngine.folder, (orignalName + ++idx) + ".json") + ".json"

      return name

    @saveDebounce: 10000 # For node we can wait longer :)
    @folder: "./LogAndRoll"
    @engines.push(@)
    @supported: ->

      try
        fs = require "fs"
        path = require "path"
        os = require "os"

        if not fs.existsSync(NodeFileSystemStorageEngine.folder)
          fs.mkdirSync(NodeFileSystemStorageEngine.folder)

        return yes
      catch e
        return no

    deviceId: ->
      return os.hostname()

    nextBlob: (callback) ->
      fs.readdir NodeFileSystemStorageEngine.folder, (err, files) =>
        @sendingKeys = []
        @blobs = []
        max = 0
        idx = 0
        for file in files
          if StorageEngine.isValidBlobName(file)
            max++
            fileToRead = path.join(NodeFileSystemStorageEngine.folder, file)
            @sendingKeys.push(fileToRead)
            fs.readFile(fileToRead, (err, data) =>
              @blobs = @blobs.concat(JSON.parse data)
              if idx == max-1
                callback(
                  logs: @blobs
                )

              idx++
            )

    # Capture blob keys for removing later
    sendingKeys: null

    deleteBlob: (blob) ->
      for key in @sendingKeys
        fs.unlink(key)
      @sendingKeys = []

    appendBlob: (blob, callback) ->
      name = NodeFileSystemStorageEngine.blobName()

      try
        fs.writeFile(name, JSON.stringify(blob), ->
          callback()
        )
      catch e
        callback(StorageEngine.error.full)

)()