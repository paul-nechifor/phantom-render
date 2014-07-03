exports.Renderer = require './Renderer'
exports.render = (data, imagePath, opts, cb) ->
  r = new exports.Renderer data, imagePath, opts
  r.render cb
