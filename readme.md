# Phantom Render

Programatically transform web pages to images using PhantomJS.

## Install

This requires that you have PhantomJS installed:

    sudo apt-get install phantomjs

## Example

```javascript
var render = require('./').render;
var data = "<p>Hello world!</p>";
var opts = {width: 300, height: 200};
render(data, 'hello.png', opts, function (err) {
  console.log('done', err);
});
```

## License

MIT
