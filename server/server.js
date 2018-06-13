const restify = require('restify')

const restifyCore = restify.createServer()

restifyCore.get('/', function (req, res, next) {
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8" />
      <title>bookwerx-ui-elm</title>
    </head>
    <body>
      <div id="main"></div>
      <script src="/webpack.js"></script>
    </body>
    </html>
  `

  res.sendRaw(html)
  next()
})

restifyCore.get('/webpack.js', restify.plugins.serveStatic({
  directory: './dist',
  default: 'index.html'
}))

module.exports = async (mode, port, bwcoreUrl) => {
  await restifyCore.listen(port)
  console.log('The bookwerx-ui-elm server is listening on port', port)
  return restifyCore
}
