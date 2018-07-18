require('bulma/css/bulma.css')

require('./index.html')

const logoIcon = require('./bw-redline.png')
// const logoImg = document.getElementById('logo');
// logoImg.src = logoIcon

const Elm = require('./elm/App.elm')
const mountNode = document.getElementById('main')

Elm.App.embed(mountNode)
