NodeRequestSendEngine = null
(->

  os = http = url = urlObj = null

  class NodeRequestSendEngine extends SendEngine

    @nice: 0

    # Used in every engine to expose their presence
    @engines.push @

    @supported: ->

      try
        http = require "http"
        url = require "url"
        os = require "os"

        return yes
      catch e
        return no

    sendBlob: (blob, callback) ->

      urlObj = url.parse(SendEngine.blobEndpoint(@logAndRoll))
      blob.deviceDetails =
        version: "#{process.version}"
        platform: "NodeJS"
        type: "server"

      blob.deviceDetails = extend(blob.deviceDetails, @logAndRoll.device)

      blobString = JSON.stringify(blob)

      headers =
        "Content-Type": "application/json"
        "Content-Length": blobString.length

      options =
        host: urlObj.hostname
        port: urlObj.port
        path: urlObj.path
        method: "POST"
        headers: headers

      req = http.request(options, (res) ->
        res.setEncoding "utf-8"
        responseText = ""
        res.on "data", (data) ->
          responseText += data

        res.on "end", ->
          if responseText == "OK"
            callback()

      )

      req.on "error", (e) ->
        callback(SendEngine.error.sending_failed)

      req.write(blobString)
      req.end()
)()