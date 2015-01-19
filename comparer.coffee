_ = require "underscore"
FileReader = require "./file-reader"

console.time "Execution time"

module.exports = class Comparer
  constructor: (@destinationFolder) ->

  printSameFileGroups: ->
    FileReader.getSameFileGroups @destinationFolder, (sameFilesGroups) ->
      print(sameFilesGroups)
      console.timeEnd "Execution time"

  print = (sameFilesGroups) ->
    validFileGroups = _.filter sameFilesGroups, (fileGroup) ->
      fileGroup.length >= MIN_FILES_IN_GROUP = 2

    _.each validFileGroups, (filePaths) ->
      _.each filePaths, (filePath) ->
        console.log filePath
      console.log ""
