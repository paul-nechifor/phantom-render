fs = require 'fs'
tmp = require 'tmp'
{spawn} = require 'child_process'

module.exports = class Renderer
  constructor: (@data, @imagePath, @opts) ->
    @dataPath = null
    @scriptPath = null
    @cb = null

  render: (cb) ->
    @cb = cb
    @writeAll (err) =>
      return @cleanUp err if err
      @runPhantom (err) =>
        return @cleanUp err if err
        @cleanUp()

  cleanUp: (err) ->
    fs.unlinkSync @dataPath if @dataPath
    fs.unlinkSync @scriptPath if @scriptPath
    @cb err

  writeAll: (cb) ->
    tmp.file {postfix: '.html'}, (err, path) =>
      return cb err if err
      @dataPath = path
      tmp.file {postfix: '.js'}, (err, path) =>
        return cb err if err
        @scriptPath = path

        scriptData = @generatePhantomFile()
        fs.writeFile @dataPath, @data, (err) =>
          return cb err if err
          fs.writeFile @scriptPath, scriptData, cb

  generatePhantomFile: ->
    """
      var webPage = require('webpage');
      var page = webPage.create();

      page.viewportSize = {
        width: #{@opts.width or 1024},
        height: #{@opts.height or 768}
      };

      page.open(#{JSON.stringify @dataPath}, function () {
        page.render(#{JSON.stringify @imagePath});
        phantom.exit();
      });
    """

  runPhantom: (cb) ->
    s = spawn 'phantomjs', [@scriptPath]
    s.on 'close', (code) ->
      return cb 'phantom-err-' + code unless code is 0
      cb()
