const restify = require('restify')
const restifyCore = restify.createServer()

restifyCore.get('/webpack.js', restify.plugins.serveStatic({
  directory: './dist'
}))

restifyCore.get('/*', restify.plugins.serveStatic({
  directory: './dist',
  file: 'index.html'
}))

module.exports = async (mode, port, bwcoreUrl) => {
  await restifyCore.listen(port)
  console.log('The bookwerx-ui-elm server is listening on port', port)
  return restifyCore
}
