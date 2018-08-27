/* global Cypress, before, cy, describe */ // Silence of the linter

const shared = require('../shared')

const serverConstants = require('../../../server/constants.js')

const bwURL = Cypress.env('BWUI_URL')

before(function () {
  if (!bwURL) {
    cy.log(serverConstants.NO_BWUI_URL_DEFINED)
  }
  cy.visit(bwURL + '/#ui/categories/edit')
})

describe('/categories', function () {
  shared.verifyEmbededInTemplate()
})
