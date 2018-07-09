/* global Cypress, before, cy, describe, it */ // Silence of the linter

const serverConstants = require('../../../server/constants.js')

const bwURL = Cypress.env('BWUI_URL')

before(function () {
  if (!bwURL) {
    cy.log(serverConstants.NO_BWUI_URL_DEFINED)
    cy.visit(bwURL + '/accounts')
  }
})

it('has a nav bar with all the expected links', function () {
  cy.get('nav')
  cy.get('nav >> a').contains('Transactions')
  cy.get('nav >> a').contains('Accounts')
  cy.get('nav >> a').contains('Currencies')
})
