require('bulma/css/bulma.css')

// Require index.html so it gets copied to dist
require('./index.html')

const Elm = require('./elm/App.elm')
const mountNode = document.getElementById('main')

Elm.App.embed(mountNode)
