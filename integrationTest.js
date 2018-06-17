/* In order to perform integration testing we're going to start with a completely empty db and perform many operations on it. The testing follows the following phases:

1. Prolog.  We need to obtain an empty db and generate some keys.  We 'empty' the db by enumerating all existing items and deleting them.

2. GenericCRU testing.  Here we attempt to create, read, and update the documents in the various collections.  I didn't say delete because we want to keep these records for subsequent testing and we'll do the delete testing after all the other tests.

3. Special CRU testing for the interaction of integrity constraints between certain collections.  Two examples are:
*  Currencies/Distributions/Transactions
*  Accounts/Categories

4. Aggregate testing.  There are some functions that work with broad swaths of the data.  For example: one function summarizes distributions for a particular category, by time period.  Now that the db is stuffed with data, we have a good opportunity to test these functions.

5. Special delete testing for the items in Special CRU testing.

6. GenericDelete testing.

7. Verify that the db is now completely empty.  No documents in any collection.

For some of these categories, generally for the generic tests, we will run the tests twice, once for each of our example piKeys. The testing will fail if the documents from one key are mixed up with documents from another key.

For some of these categories, generally for the specialized constraint testing, we only run the test once for a single api key. The CRUD operations are tested elsewhere and in these tests we only want to focus on the integrity constraints.

Almost all routes (except for the key generating routes) should be separately tested for no key, bad key, and good key but bad signature.

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

run().catch(error => console.error(error))

async function run () {
  const restifyCore = await server(
    process.env.BW_MODE,
    process.env.BW_PORT,
    process.env.BWCORE_URL
  )

  // import genericCRUDTest    from './app/integrationTest/generic_crud_test'
  // import accountsCategories from './app/integrationTest/accountsCategories'
  // import prolog             from './app/integrationTest/prolog'
  // import genericCRU         from './app/integrationTests/basicCRUD/genericCRU'
  // const genericCRU = require('./app/integrationTests/basicCRUD/genericCRU.js')
  // import genericDel         from './app/integrationTests/basicCRUD/genericDel'

  // const jsonClient = restifyClients.createJsonClient({url: 'http://127.0.0.1:' + process.env.BW_PORT});

  // Get two sets of keys to play with.
  //  .then(result => {
  //   const pReadDawgFood =  new Promise((resolve, reject) => {
  //     jsonClient.post('/dawgfood', {}, function (err, req, res, obj) {
  //       if (err) resolve(err) // in this case I expect an error
  //     })
  //   })
  // const pReadKeys =  new Promise((resolve, reject) => {
  //  jsonClient.post('/keys', {}, function (err, req, res, obj) {
  //    if (err) reject(err)
  //    console.log('%d -> %j', res.statusCode, res.headers);
  //    console.log('%j', obj);
  //    resolve(obj)
  //  })
  // })

  // const p2 = pReadDawgFood.then((result)=>{
  // console.log('72 dawgfood error',result)
  // Promise.resolve(result)
  // })
  //    const key1 = await (async (jsonClient) => {
  // const pPostKey1 = new Promise((resolve, reject) => {
  //      return new Promise((resolve, reject) => {
  //        jsonClient.post('/keys', {}, function (err, req, res, obj) {
  //          if (err) reject(err)
  //          console.log('%d -> %j', res.statusCode, res.headers)
  //          console.log('%j', obj)
  //          resolve(obj)
  //        })
  //      })
  //    })(jsonClient)

  //    const key2 = await (async (jsonClient) => {
  //      return new Promise((resolve, reject) => {
  //        jsonClient.post('/keys', {}, function (err, req, res, obj) {
  //          if (err) reject(err)
  //          console.log('%d -> %j', res.statusCode, res.headers)
  //          console.log('%j', obj)
  //          resolve(obj)
  //        })
  //      })
  //    })(jsonClient)

  //     const pPostKey2 = new Promise((resolve, reject) => {
  //       jsonClient.post('/keys', {}, function (err, req, res, obj) {
  //         if (err) reject(err)
  //         console.log('%d -> %j', res.statusCode, res.headers)
  //         console.log('%j', obj)
  //         resolve(obj)
  //       })
  //     })

  // return Promise.all([pReadDawgFood,pReadKey1,pReadKey2])
  //     return Promise.all([pPostKey1, pPostKey2])
  //   })
  //   .then((result) => {
  //     keys = [
  //       result[0],
  //       result[1]
  //     ]
  //     console.log(134, result[0], result[1])
  //   })

  // 2. GenericCRU testing
  //    await (async (jsonClient, keys) => {
  // .then(result => {
  //  return genericCRU({collName: 'accounts', jsonClient, keys, newDoc1: testData.accountBank, newDoc2: testData.accountCash, pn: 20})
  // })
  // .then(result => {return genericCRU({collName:'categories', jsonClient,  keys, newDoc1: testData.categoryAsset, newDoc2: testData.categoryExpense, pn:21})})
  // await genericCRU({collName: 'categories', jsonClient,  keys, newDoc1: testData.categoryAsset, newDoc2: testData.categoryExpense, pn:21})

  //   .then(result => { return genericCRU({ collName: 'currencies', jsonClient, keys, newDoc1: testData.currencyCNY, newDoc2: testData.currencyRUB, pn: 22 }) })
  let driver = await new Builder().forBrowser('firefox').build()

  // 1. Look at the list of currencies.  Wait for the loader, wait for the list, delete any existing entries.
    let finished = false
    do {
      await driver.get('http://localhost:3004/currencies')
      await driver.wait(until.elementLocated(By.css('.loader')))
      await driver.wait(until.elementLocated(By.css('#currencies-index')))
      const currencyRows = await driver.findElements(By.css('tbody > tr'))
      if (currencyRows.length > 0) {
        // There must be at least one row, so delete the first row.  This only looks for "button" but if we specify the id, we can't find it.  Why?
        const deleteButton = await currencyRows[0].findElement(By.css('button'))
        await deleteButton.sendKeys('', Key.ENTER)
      } else {
        finished = true
      }
    } while (!finished)


  // 2. Find the "/currencies/add" link
  await driver.wait(until.elementLocated(By.css('a#currencies-add')))
  const addLink = await driver.findElements(By.css('a#currencies-add'))
  await addLink[0].sendKeys('', Key.RETURN)

  await driver.wait(until.elementLocated(By.css('div#currencies-add')))
  const currenciesAdd = await driver.findElements(By.css('div#currencies-add'))
  if (currenciesAdd.length !== 1) throw new Error('There should be exactly 1 element like this.')

  // 3. Enter a new currency
  // 3.1 Enter a new symbol
  await driver.wait(until.elementLocated(By.css('input#symbol')))
  const symbolInput = await driver.findElements(By.css('input#symbol'))
  if (symbolInput.length !== 1) throw new Error('There should be exactly 1 element like this.')
  await symbolInput[0].sendKeys(testData.currencyCNY.symbol)

  // 3.2 Enter a new title
  await driver.wait(until.elementLocated(By.css('input#title')))
  const titleInput = await driver.findElements(By.css('input#title'))
  if (titleInput.length !== 1) throw new Error('There should be exactly 1 element like this.')
  await titleInput[0].sendKeys(testData.currencyCNY.title)

  // 3.3 Save the new currency
  await driver.wait(until.elementLocated(By.css('button#save')))
  const saveButton = await driver.findElements(By.css('button#save'))
  if (saveButton.length !== 1) throw new Error('There should be exactly 1 element like this.')
  await saveButton[0].sendKeys('', Key.ENTER)

  // 4. Go there and wait for the loader to finish.  Verify what we see.
  await driver.get('http://localhost:3004/currencies')
  await driver.wait(until.elementLocated(By.css('.loader')))
  await driver.wait(until.elementLocated(By.css('#currencies-index')))
  const currencyRows1 = await driver.findElements(By.css('tbody > tr'))
  if (currencyRows1.length !== 1) throw new Error('There should be exactly 1 element like this.')

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

  // 7. Verify that the db is now completely empty.
  console.log(colors.green('All tests passed'))

  await restifyCore.close()
}
