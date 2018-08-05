const restify = require('restify')
const restifyCore = restify.createServer()

const httpProxy = require('http-proxy')

module.exports = async (bwUIPort, bwCoreHost, bwCorePort) => {
  restifyCore.get('/', restify.plugins.serveStatic({
    directory: './dist',
    file: 'index.html'
  }))

  restifyCore.get('/webpack.js', restify.plugins.serveStatic({
    directory: './dist'
  }))

  restifyCore.get('/ui/*', restify.plugins.serveStatic({
    directory: './dist',
    file: 'index.html'
  }))

  // Proxy to bookwerx_core

  const bwcoreHostAndPort = {
    host: bwCoreHost,
    post: bwCorePort
  }

  const n = 'http://' + bwCoreHost + ':' + bwCorePort
  console.log(n)
  const proxy = httpProxy.createProxyServer({target: n})

  restifyCore.del('/*', function (req, res) {
    proxy.proxyRequest(req, res, bwcoreHostAndPort)
  })

  restifyCore.get('/*', function (req, res) {
    proxy.proxyRequest(req, res, bwcoreHostAndPort)
  })

  restifyCore.patch('/*', function (req, res) {
    proxy.proxyRequest(req, res, bwcoreHostAndPort)
  })

  restifyCore.post('/*', function (req, res) {
    proxy.proxyRequest(req, res, bwcoreHostAndPort)
  })

  await restifyCore.listen(bwUIPort)
  console.log('The bookwerx-ui-elm server is listening on port', bwUIPort)
  return restifyCore
}
