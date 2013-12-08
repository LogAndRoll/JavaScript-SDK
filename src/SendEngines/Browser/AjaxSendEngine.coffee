AjaxSendEngine = null

(->
  createCORSRequest = (method, url) ->
    return null if not XMLHttpRequest?
    xhr = new XMLHttpRequest()
    if "withCredentials" of xhr

      # Check if the XMLHttpRequest object has a "withCredentials" property.
      # "withCredentials" only exists on XMLHTTPRequest2 objects.
      xhr.open method, url, true
    else unless typeof XDomainRequest is "undefined"

      # Otherwise, check if XDomainRequest.
      # XDomainRequest only exists in IE, and is IE's way of making CORS requests.
      xhr = new XDomainRequest()
      xhr.open method, url
    else

      # Otherwise, CORS is not supported by the browser.
      xhr = null

    return xhr

  class AjaxSendEngine extends SendEngine

    # Used in every engine to expose their presence
    @engines.push @
    @nice: 1

    @supported: ->
      xhr = createCORSRequest('GET', serverUrl)

      if !xhr
        return no

      return yes

    sendBlob: (blob, callback) ->

      xhr = createCORSRequest('POST', SendEngine.blobEndpoint(@logAndRoll))
      xhr.setRequestHeader('Content-Type', 'application/json')

      # process the response.
      xhr.onload = ->
        responseText = xhr.responseText
        if responseText == "OK"
          callback()
        else
          callback(SendEngine.error.sending_failed)

      xhr.onerror = ->
        callback(SendEngine.error.sending_failed)

      xhr.send(JSON.stringify(blob))

)()