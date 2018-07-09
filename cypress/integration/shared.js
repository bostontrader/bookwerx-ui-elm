/* global cy, it */ // Silence of the linter

exports.verifyEmbededInTemplate = function () {
  it('has a header', function () {
    cy.log('into header')
    cy.get('#content #header')
  })

  it('has a nav bar with all the expected links', function () {
    cy.get('#content nav')
    cy.get('#content nav a').contains('Transactions')
    cy.get('#content nav a').contains('Accounts')
    cy.get('#content nav a').contains('Currencies')
  })

  it('has a middle', function () {
    cy.get('#content #middle')
  })

  it('has a left-pane', function () {
    cy.get('#content #middle #left-pane')
  })

  it('has a main-content', function () {
    cy.get('#content #middle #main-content')
  })

  it('has a footer', function () {
    cy.get('#content  #footer')
  })
}
