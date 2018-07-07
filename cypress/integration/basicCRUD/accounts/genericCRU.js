const testData = require('bookwerx-testdata')

// Starting from the index page of the collection, count the existing rows, if any. If verifyDoc contains a record, verify that the first row contains the values therein.
const verifyIndex = ({collName, cy, expectedCnt, verifyDoc}) => {
  cy.get('div#' + collName + '-index')

  if (expectedCnt === 0) {
    cy.get('#' + collName + '-empty')
  } else {
    cy.get('tbody').find('tr').should('have.length', expectedCnt)

    // Possibly verify that the first row contains the expected values.
    if (verifyDoc) {
      cy.get('tbody').first().contains(verifyDoc.title)
    }
  }
}

// Starting from the index page of the collection, navigate to the add new document page, add a new document, and click the button to return to collection-index
const addNew = ({cy, collName, newDoc}) => {
  // 1. Navigate to the add page
  cy.get('a#' + collName + '-add').click()
  cy.get('div#' + collName + '-add')

  // 2. Enter the field values
  cy.get('input#title').type(newDoc.title)

  // 3. Save the new document
  cy.get('button#save').click()

  // Probably want to wait for success feedback.
  // The POST request is mysteriously getting aborted.  This seems to fix the problem.
  cy.wait(['@POST_accounts'])

  // 4. Now return to collection-index
  cy.get('a#' + collName + '-index').click()
}

// Perform a basic CRU test
module.exports = ({bwURL, collName, cy}) => {
  // 1. Now read the documents collection and post new documents and demonstrate that we correctly have 0, 1, or 2 documents in the collection.

  // Go to the index.  Do we have exactly zero documents now?
  cy.visit(bwURL + '/' + collName)
  cy.get('.loader')
  verifyIndex({bwURL, collName, cy, expectedCnt: 0})

  // Navigate to the add form, add a new document, and navigate back to the index.
  addNew({cy, collName, newDoc: testData.accountBank})

  // Starting from the index, do we have exactly one document now? Are the fields correct?
  verifyIndex({bwURL, collName, cy, expectedCnt: 1, verifyDoc: testData.accountBank})

  // Navigate to the add form, add a new document, and navigate back to the index.
  addNew({cy, collName, newDoc: testData.accountCash})

  // Starting from the index, do we have exactly two documents now?
  verifyIndex({bwURL, collName, cy, expectedCnt: 2})

  // 2. GET a document, using a good id for an existing document via the UI, a well formed id that refers to a non-existent document via hacking the URL, and a mal-formed id.

  // 2.1 We should presently be on the /accounts index page. Follow the UI, pick the first account in the list, and attempt to edit it.
  cy.get('tbody').find('tr').first().find('a').click()
  cy.get('.loader')
  cy.get('div#accounts-edit')
  cy.get('input').should('have.value', testData.accountBank.title)

  // 2.2 Now try to retrieve a well-formed, but non-existent id
  cy.visit(bwURL + '/' + collName + '/666666666666666666666666')
  cy.get('.loader')
  cy.get('div#errors')
  cy.get('tbody > tr').first().contains('account 666666666666666666666666 does not exist')

  // 2.3 Now try to retrieve a badly formed id
  cy.visit(bwURL + '/' + collName + '/catfood')
  cy.get('.loader')
  cy.get('div#errors')
  cy.get('tbody > tr').first().contains('Argument passed in must be a single String of 12 bytes or a string of 24 hex characters')

  // 3. PATCH  a document, using a good id for an existing document.  It's tempting to also test the same using a well formed id that refers to a non-existent document, and a mal-formed id.  But we cannot create these cases from the UI so ignore them.

  // 3.1 We should be on the edit page.  Find the nav button and return to the index page.
  cy.get('a#accounts-index').click()

  // 3.2 Navigate to the edit page
  cy.get('tbody').find('tr').first().find('a').click()
  cy.get('.loader')

  // 3.3 Update a field
  cy.get('input#title').clear().type('newtitle')

  // 3.4 Save the changed document
  cy.get('button#save').click()

  // Probably want to wait for success feedback.
  // The POST request is mysteriously getting aborted.  This seems to fix the problem.
  // cy.wait(['@POST_accounts'])

  // 3.5. Now return to collection-index and verify that the field has been changed.
  cy.get('a#' + collName + '-index').click()
  cy.get('tbody').first().contains('newtitle')
}
