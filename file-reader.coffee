_ = require "underscore"
async = require "async"
crypto = require "crypto"
fs = require "fs"
walk = require "walk"

module.exports = class FileReader
  sameFilesGroups = {}
  allFilesPaths = []

  @getSameFileGroups: (destinationFolder, callback) ->
    walker = walk.walk(destinationFolder, followLinks: false)

    walker.on "file", (root, stat, next) ->
      addNotEmptyFilePath(root, stat)
      next()

    walker.on "end", ->
      tasks = getFileProcessingTasks()
      async.parallel tasks, (err, results) ->
        callback(sameFilesGroups);

  addNotEmptyFilePath = (root, stat) ->
    if stat.size isnt 0
      allFilesPaths.push root + "\\" + stat.name

  getFileProcessingTasks = ->
    asyncTasks = []
    _.each allFilesPaths, (filePath) ->
      asyncTasks.push (callback) ->
        getFileData filePath, (err, data) ->
          addFileToGroup(checksum(data), filePath) if not err
          callback()
    asyncTasks

  getFileData = (filePath, dataReadCallback) ->
    fs.readFile filePath, (err, data) ->
      dataReadCallback err, data

  addFileToGroup = (fileChecksum, filePath) ->
    if not sameFilesGroups[fileChecksum]?
      sameFilesGroups[fileChecksum] = []
    sameFilesGroups[fileChecksum].push filePath
    return

  checksum = (str, algorithm, encoding) ->
    crypto.createHash(algorithm or "sha256").update(str, "utf8").digest encoding or "hex"