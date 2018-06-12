const restify = require('restify')

const restifyCore = restify.createServer()

module.exports = async (mode, port, bwcore_url) => {
  await restifyCore.listen(port)
  console.log('The bookwerx-ui-elm server is listening on port', port)
}
