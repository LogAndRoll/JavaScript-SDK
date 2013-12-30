isNodeJS = process?

if isNodeJS
  require "./LogAndRollSDK.js"

  process.on "uncaughtException", (e) ->
    console.log "Caught unhandled exception: #{e} ", e.stack

logAndRoll = LogAndRoll.launch(
  appName: "test"
  APIKey: "M7Enq1DN057S1Med4B66yvHJPkLW3FrhySz"
  debug: yes
  sendTimeout: 3000
)

if isNodeJS
  # Callback for travis
  jasmineEnv = jasmine.getEnv()
  oldCallback = jasmineEnv.currentRunner().finishCallback
  jasmineEnv.currentRunner().finishCallback = ->
    oldCallback.apply this, arguments

  jasmineEnv.defaultTimeoutInterval = 10 * 1000

window.logAndRoll = logAndRoll # for console debugging

describe "Log & Roll initiation", ->

  it "Loads Log&Roll with test API key and App name", ->
    expect(logAndRoll).toBeDefined()

  it "Has access to shortcut LogNRoll function, as being made by the first initialized class", ->
    expect(LogNRoll).toBeDefined()

describe "Engine Selection", ->
  it "Should have selected a send engine", ->
    expect(logAndRoll.sendEngine).toBeDefined()

  it "Should have selected a storage engine", ->
    expect(logAndRoll.storageEngine).toBeDefined()

  it "Has selected #{logAndRoll.storageEngine.constructor.name} and #{logAndRoll.sendEngine.constructor.name}"

describe "Basic Logging", ->

  it "Logs demo log with tag: error", (done) ->

    LogNRoll("error", "Web Request failed: #{Math.random()}")
    logAndRoll.saveBlobs((saveError) ->
      expect(saveError).toBeNull()
      logAndRoll.sendLogs((sendError) ->
        expect(sendError).toBeNull()
        done()
      )
    )
