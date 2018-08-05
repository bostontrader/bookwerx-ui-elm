require('bulma/css/bulma.css')

require('./index.html')

// At this time we require this as a trick to generate a data representation of this logo, that we can then copy 'n' paste into the html.  Ugly hack, but that's the deal.
// const logoIcon = require('./bw-redline.png')

const Elm = require('./elm/App.elm')
const mountNode = document.getElementById('main')

// Find a more elegant way to feed config information into webpack/elm.
Elm.App.embed(mountNode, {
  bwcoreHost: 'localhost',
  bwcorePort: 3003
})
