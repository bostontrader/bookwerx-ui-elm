const server = require('./server/server.js')
const serverConstants = require('./server/constants.js')

// test? development? production?
if (!process.env.BWUI_MODE) {
  console.log(serverConstants.NO_OPERATING_MODE_DEFINED)
  process.exit(1)
}

if (!process.env.BWUI_PORT) {
  console.log(serverConstants.NO_PORT_DEFINED)
  process.exit(1)
}

if (!process.env.BWCORE_URL) {
  console.log(serverConstants.NO_BWCORE_URL_DEFINED)
  process.exit(1)
}

run().catch(error => console.error(error))

async function run () {
  await server(
    process.env.BWUI_MODE,
    process.env.BWUI_PORT,
    process.env.BWCORE_URL
  )
}
