# Some nice functions which can be useful troughout the SDK :)

implementError = ->
  new Error("You need to implement this method")

uniqueId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

ts = ->
  Math.round(new Date().getTime() / 1000)

extend = (object, properties) ->
  for key, val of properties
    if not object[key]?
      object[key] = val
  object

niceIfy = (obj) ->
  if typeof obj is 'object'
    return JSON.stringify(obj)
  else return obj + ""

debounce = (func, threshold, execAsap) ->
  timeout = false

  return debounced = ->
    obj = this
    args = arguments

    delayed = ->
      func.apply(obj, args) unless execAsap
      timeout = null

    if timeout
      clearTimeout(timeout)
    else if (execAsap)
      func.apply(obj, args)

    timeout = setTimeout delayed, threshold || 100