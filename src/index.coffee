gm = require "gm"
exec = require("child_process").exec
fs = require "fs"
path = require "path"

typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

module.exports = class Resize
  brunchPlugin: yes
  formats: ["gif", "jpeg", "jpg", "png"]
  _resize_binary: "pnmscale"

  constructor: (@config) ->
    @options = @config.plugins.resize
    exec "#{@_resize_binary} --version", (error, stdout, stderr) =>
      if error
        console.error "You need to have pnmscale installed. This is usually done with netpbm. Try brew install netpbm if you use homebrew."
    null

  onCompile: (generatedFiles) ->
    for imagePath, optionsSet of @options

      options = if typeIsArray optionsSet then optionsSet else [optionsSet]

      for optionSet in options
        baseDirectory = imagePath.replace /\/$/, ""
        dest = path.join @config.paths.public, optionSet.dest

        fs.mkdirSync(dest) unless fs.existsSync dest

        for imagePath in @fetchFiles baseDirectory
          resizedPath = path.join(
            dest,
            path.relative baseDirectory, imagePath
          )

          unless @resizedExists resizedPath
            @createResized resizedPath, imagePath, optionSet

  # Borrowed and modified from imageoptimizer
  fetchFiles: (directory) ->
    recursiveFetch = (directory) ->
      files = []
      prependBase = (filename) ->
        path.join directory, filename
      isDirectory = (filename) ->
        fs.statSync(prependBase filename).isDirectory()
      isFile = (filename) ->
        fs.statSync(prependBase filename).isFile()

      directoryFiles = fs.readdirSync directory
      nextDirectories = directoryFiles.filter isDirectory
      fileFiles = directoryFiles.filter(isFile).map prependBase
      files = files.concat fileFiles

      for d in nextDirectories
        files = files.concat recursiveFetch prependBase d

      files

    recursiveFetch directory

  createResized: (imagePath, src, options) ->
    gm(src).resize(options.width, options.height).write imagePath, (error) ->
      console.error error if error

  resizedExists: (imagePath) ->
    fs.existsSync imagePath

