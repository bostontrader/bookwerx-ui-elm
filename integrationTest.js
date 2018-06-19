/* In order to perform integration testing we're going to start with a completely empty db and perform many operations on it. The testing follows the following phases:

1. Prolog. Start the server and brainwipe the db.  In this context, we will use the UI to individually find and delete records because it's probably not a good idea to tap directly into the underlying db.

2. GenericCRU testing.  Here we attempt to create, read, and update the documents in the various collections.  I didn't say delete because we want to keep these records for subsequent testing and we'll do the delete testing after all the other tests.

3. Special CRU testing for the interaction of integrity constraints between certain collections.  Two examples are:
*  Currencies/Distributions/Transactions
*  Accounts/Categories

4. Aggregate testing.  There are some functions that work with broad swaths of the data.  For example: one function summarizes distributions for a particular category, by time period.  Now that the db is stuffed with data, we have a good opportunity to test these functions.

5. Special delete testing for the items in Special CRU testing.

6. GenericDelete testing.

7. Verify that the db is now completely empty.  No documents in any collection.

 */
const colors = require('colors/safe')
const {Builder, By, Key, until} = require('selenium-webdriver')
const testData = require('bookwerx-testdata')

const server = require('./server/server.js')
const serverConstants = require('./server/constants.js')

// test? development? production?
if (!process.env.BW_MODE) {
  console.log(serverConstants.NO_OPERATING_MODE_DEFINED)
  process.exit(1)
}

if (!process.env.BW_PORT) {
  console.log(serverConstants.NO_PORT_DEFINED)
  process.exit(1)
}

if (!process.env.BWCORE_URL) {
  console.log(serverConstants.NO_BWCORE_URL_DEFINED)
  process.exit(1)
}

if (!process.env.BWUI_DOMAIN) {
  console.log(serverConstants.NO_BWUI_DOMAIN_DEFINED)
  process.exit(1)
}

run().catch(error => console.error(error))

async function run () {
  // 1. Prolog

  // 1.1 We will need the UI server running
  const restifyCore = await server(
    process.env.BW_MODE,
    process.env.BW_PORT,
    process.env.BWCORE_URL
  )

  // 1.2 We need a connection to a browser to make it play tricks
  let seleniumDriver = await new Builder().forBrowser('firefox').build()

  // 1.3 Now delete everything

  // Look at the list of currencies.  Wait for the loader, wait for the list, delete any existing entries.
  let finished = false
  const bwURL = 'http://' + process.env.BWUI_DOMAIN + ':' + process.env.BW_PORT

  do {
    await seleniumDriver.get(bwURL + '/currencies')

    await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
    await seleniumDriver.wait(until.elementLocated(By.css('#currencies-index')))
    const currencyRows = await seleniumDriver.findElements(By.css('tbody > tr'))
    if (currencyRows.length > 0) {
      // There must be at least one row, so delete the first row.  This only looks for "button" but if we specify the id, we can't find it.  Why?
      const deleteButton = await currencyRows[0].findElement(By.css('button'))
      await deleteButton.sendKeys('', Key.ENTER)
    } else {
      finished = true
    }
  } while (!finished)

  // 2. genericCRU
  // await genericCRU({collName: 'currencies', httpClient: jsonClient, newDoc1: testData.currencyCNY, newDoc2: testData.currencyRUB, pn: 22})
  const genericCRU = require('./integrationTests/basicCRUD/genericCRU')
  await genericCRU({bwURL, collName: 'currencies', seleniumDriver, newDoc1: testData.currencyCNY, newDoc2: testData.currencyRUB})

  //      await genericCRU({ collName: 'currencies', httpClient: jsonClient, keys, newDoc1: testData.currencyCNY, newDoc2: testData.currencyRUB, pn: 22 })

  // .then(result => {return genericCRU({collName:'transactions', jsonClient, keys, newDoc1: testData.transaction1, newDoc2: testData.transaction2, pn: 23})})
  //    })(jsonClient, [key1, key2])

  //    process.exit(0)
  //  } catch (e) {
  // Deal with the fact the chain failed
  //    console.log(e)
  //    process.exit(1)
  //  }
  // })()

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

  //   .then(result => {
  //     process.exit()
  //   })
  seleniumDriver.close()
  console.log(colors.green('All tests passed'))

  await restifyCore.close()
}
