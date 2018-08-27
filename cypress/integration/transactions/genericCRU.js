const testData = require('bookwerx-testdata')

// Starting from the index page of the collection, count the existing rows, if any. If verifyDoc contains a record, verify that the first row contains the values therein.
const verifyIndexPage = ({collName, cy, expectedCnt, verifyDoc}) => {
  cy.get('div#' + collName + '-index')

  if (expectedCnt === 0) {
    cy.get('#' + collName + '-empty')
  } else {
    cy.get('tbody').find('tr').should('have.length', expectedCnt)

    // Possibly verify that the first row contains the expected values.
    if (verifyDoc) {
      cy.get('tbody').first().contains(verifyDoc.datetime)
      cy.get('tbody').first().contains(verifyDoc.note)
    }
  }
}

// Starting from the index page of the collection, navigate to the add new document page, add a new document.  Verify that we're now on the edit page, verify the expected input values, and click the button to return to collection-index.
const addNew = ({cy, collName, newDoc}) => {
  // 1. Navigate to the add page
  cy.get('a#' + collName + '-add').click()
  cy.get('div#' + collName + '-add')

  // 2. Enter the field values
  cy.get('input#datetime').type(newDoc.datetime, {delay: 25})
  cy.get('input#note').type(newDoc.note, {delay: 25})

  // 3. Save the new document
  cy.get('button#save').click()

  // 4. Verify that we redirect to the edit page and that we have the proper flash message.  We will verify the correct opertion of the edit page in another test.
  cy.get('div.notification.is-success')
  cy.get('div#' + collName + '-edit')

  // 5. Now return to collection-index
  cy.get('a#' + collName + '-index').click()
}

// Perform a basic CRU test
module.exports = ({bwURL, collName, cy}) => {
  // 1. Now read the documents collection and post new documents and demonstrate that we correctly have 0, 1, or 2 documents in the collection.

  // Go to the index.  Do we have exactly zero documents now?
  cy.visit(bwURL + '/#ui/' + collName)
  verifyIndexPage({bwURL, collName, cy, expectedCnt: 0})

  // Navigate to the add form, add a new document, and navigate back to the index.
  addNew({cy, collName, newDoc: testData.transaction1})

  // Starting from the index, do we have exactly one document now? Are the fields correct?
  verifyIndexPage({bwURL, collName, cy, expectedCnt: 1, verifyDoc: testData.transaction1})

  // Navigate to the add form, add a new document, and navigate back to the index.
  addNew({cy, collName, newDoc: testData.transaction2})

  // Starting from the index, do we have exactly two documents now?
  verifyIndexPage({bwURL, collName, cy, expectedCnt: 2})

  // 2. GET a document, using a good id for an existing document via the UI, a well formed id that refers to a non-existent document via hacking the URL, and a mal-formed id.

  // 2.1 We should presently be on the /transactions index page. Follow the UI, pick the first transaction in the list, and attempt to edit it.
  cy.get('tbody').find('tr').first().find('a').click()
  cy.get('div#transactions-edit')
  cy.get('input#datetime').should('have.value', testData.transaction1.datetime)
  cy.get('input#note').should('have.value', testData.transaction1.note)

  // 2.2 Now try to retrieve a well-formed, but non-existent id
  cy.visit(bwURL + '/#ui/' + collName + '/666666666666666666666666')
  cy.get('div#errors')
  cy.get('tbody > tr').first().contains('transaction 666666666666666666666666 does not exist')

  // 2.3 Now try to retrieve a badly formed id.  There's something wrong with this test.  It finds the error message from the prior test before the visit command returns the new error message.
  // cy.visit(bwURL + '/#ui/' + collName + '/catfood')
  // cy.wait(1000) //
  // cy.get('div#errors')
  // cy.get('tbody > tr').first().contains('Argument passed in must be a single String of 12 bytes or a string of 24 hex characters')

  // 3. PATCH  a document, using a good id for an existing document.  It's tempting to also test the same using a well formed id that refers to a non-existent document, and a mal-formed id.  But we cannot create these cases from the UI so ignore them.

  // 3.1 We should be on the edit page.  Find the nav button and return to the index page.
  cy.get('a#transactions-index').click()

  // 3.2 Navigate to the edit page
  cy.get('tbody').find('tr').first().find('a').click()

  // 3.3 Update the fields
  cy.get('input#datetime').clear().type(testData.transaction2.datetime, {delay: 25})
  cy.get('input#note').clear().type(testData.transaction2.note, {delay: 25})

  // 3.4 Save the changed document
  cy.get('button#save').click()

  // 3.5 Verify proper flash message
  cy.get('div.notification.is-success')

  // 3.6. Now return to collection-index and verify that the fields have changed.
  cy.get('a#' + collName + '-index').click()
  cy.get('tbody').first().contains(testData.transaction2.datetime)
  cy.get('tbody').first().contains(testData.transaction2.note)
}
