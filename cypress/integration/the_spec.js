/* global Cypress, before, cy, describe, it */ // Silence of the linter

/* In order to perform integration testing we're going to start with a completely empty db and perform many operations on it. The testing follows the following phases:

1. Prolog. Start the servers and brainwipe the db.

In order to run these tests, we need _two_ servers, bookwerx-ui-elm and bookwerx-core, as well as a mongod to be already running and happly playing together.  In addition, the mongod must be brainwiped in order to start with a fresh slate.  Doing all this and/or ensuring that it's all running correctly is not something that the test software ought to deal with.  Instead, whatever process launches the test should do this.  However it happens, make sure it does happen.

Note: Be sure to coordinate the correct db to work with when starting bookwerx-core and doing the brainwipe.

2. GenericCRU testing.  Here we attempt to create, read, and update the documents in the various collections.  I didn't say delete because we want to keep these records for subsequent testing and we'll do the delete testing after all the other tests.

3. Special CRU testing for the interaction of integrity constraints between certain collections.  Two examples are:
*  Currencies/Distributions/Transactions
*  Accounts/Categories

4. Aggregate testing.  There are some functions that work with broad swaths of the data.  For example: one function summarizes distributions for a particular category, by time period.  Now that the db is stuffed with data, we have a good opportunity to test these functions.

5. Special delete testing for the items in Special CRU testing.

6. GenericDelete testing.

7. Verify that the db is now completely empty.  No documents in any collection.

 */

const testData = require('bookwerx-testdata')

const serverConstants = require('../../server/constants.js')

const bwURL = Cypress.env('BWUI_URL')

describe('The whole damn thing works', function () {
  before(function () {
    if (!bwURL) {
      cy.log(serverConstants.NO_BWUI_URL_DEFINED)
    }

    cy.server()

    // There's a mystery whereby POSTs to these routes get aborted.  This seems to fix the problem.
    cy.route('POST', '**/accounts').as('POST_accounts')
    cy.route('POST', '**/currencies').as('POST_currencies')
    cy.route('POST', '**/transactions').as('POST_transactions')
  })

  it('it rubs the lotion on its skin', function () {
    // 2. genericCRU
    let genericCRU

    genericCRU = require('./basicCRUD/accounts/genericCRU')
    genericCRU({bwURL, collName: 'accounts', cy, newDoc1: testData.accountBank, newDoc2: testData.accountCash})

    genericCRU = require('./basicCRUD/currencies/genericCRU')
    genericCRU({bwURL, collName: 'currencies', cy, newDoc1: testData.currencyCNY, newDoc2: testData.currencyRUB})

    genericCRU = require('./basicCRUD/transactions/genericCRU')
    genericCRU({bwURL, collName: 'transactions', cy, newDoc1: testData.transaction1, newDoc2: testData.transaction2})
    // 3. CustomCRU testing specialized for particular collections./
    // .then(() => {return accountsCategories({jsonClient,  keys, pn:30})})

    // const p = new Promise( (resolve, reject) => {
    // reject('promise rejected')
    // resolve()
    //

    // .then(result => {
    // let priorResults = {}
    // return distributionsTest.testRunner(7, testData, priorResults)
    // })

    // accounts_categories are not manipulated via a public API, so there's no direct testing
    // of CRUD or other operations.  Instead, the CRUD operations of accounts should reveal
    // or change the state of accounts_categories.  Test that here.
    // .then(result => {
    // return accountsCategoriesTest.testRunner(9, testData)
    // })

    // 4. Aggregate testing.

    // 5. Special delete testing for the items in Special CRU testing.

    // 6. Generic delete testing.
    // .then(result => {return genericDel({collName:'accounts', jsonClient,  keys, pn:60})})
    // .then(result => {return genericDel({collName:'categories', jsonClient,  keys, pn:61})})
    // .then(result => {return genericDel({collName:'currencies', jsonClient,  keys, pn:62})})
    // .then(result => {return genericDel({collName:'transactions', jsonClient,  keys, pn:63})})
  })
})
