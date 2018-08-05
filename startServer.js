const server = require('./server/server.js')
const serverConstants = require('./server/constants.js')

if (!process.env.BWUI_PORT) {
  console.log(serverConstants.NO_BWUI_PORT_DEFINED)
  process.exit(1)
}

if (!process.env.BWCORE_HOST) {
  console.log(serverConstants.NO_BWCORE_HOST_DEFINED)
  process.exit(1)
}

if (!process.env.BWCORE_PORT) {
  console.log(serverConstants.NO_BWCORE_PORT_DEFINED)
  process.exit(1)
}

run().catch(error => console.error(error))

async function run () {
  await server(
    process.env.BWUI_PORT,
    process.env.BWCORE_HOST,
    process.env.BWCORE_PORT
  )
}
