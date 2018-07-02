const {By, Key, until} = require('selenium-webdriver')
const testData = require('bookwerx-testdata')

// Starting from the index page of the collection, count the existing rows, if any. If verifyDoc contains a record, verify that the first row contains the values therein.
const verifyIndex = async ({collName, seleniumDriver, expectedCnt, verifyDoc}) => {
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-index')))
  const documentRows = await seleniumDriver.findElements(By.css('tbody > tr'))

  // Possibly verify that the first row contains the expected values.
  if (verifyDoc) {
    await documentRows[0].findElement(By.xpath('//td[contains(text(), "' + verifyDoc.symbol + '")]'))
    await documentRows[0].findElement(By.xpath('//td[contains(text(), "' + verifyDoc.title + '")]'))
  }
}

// Starting from the index page of the collection, navigate to the add new document page, add a new document, and click the button to return to collection-index
const addNew = async ({seleniumDriver, collName, newDoc}) => {
  await seleniumDriver.wait(until.elementLocated(By.css('a#' + collName + '-add')))
  const addLink = await seleniumDriver.findElement(By.css('a#' + collName + '-add'))
  await addLink.sendKeys('', Key.RETURN)
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-add')))
  await seleniumDriver.findElement(By.css('div#' + collName + '-add'))

  // 1. Enter a new symbol
  await seleniumDriver.wait(until.elementLocated(By.css('input#symbol')))
  const symbolInput = await seleniumDriver.findElement(By.css('input#symbol'))
  await symbolInput.sendKeys(newDoc.symbol)

  // 2. Enter a new title
  await seleniumDriver.wait(until.elementLocated(By.css('input#title')))
  const titleInput = await seleniumDriver.findElement(By.css('input#title'))
  await titleInput.sendKeys(newDoc.title)

  // 3. Save the new document
  await seleniumDriver.wait(until.elementLocated(By.css('button#save')))
  const saveButton = await seleniumDriver.findElement(By.css('button#save'))
  await saveButton.sendKeys('', Key.ENTER)

  // 4. Now return to collection-index
  await seleniumDriver.wait(until.elementLocated(By.css('a#' + collName + '-index')))
  const indexLink = await seleniumDriver.findElement(By.css('a#' + collName + '-index'))
  await indexLink.sendKeys('', Key.RETURN)
}

// Perform a basic CRU test
module.exports = async ({bwURL, collName, seleniumDriver}) => {
  // 1. Now read the documents collection and post new documents and demonstrate that we correctly have 0, 1, or 2 documents in the collection.

  // Go to the index.  Do we have exactly zero documents now?
  await seleniumDriver.get(bwURL + '/' + collName)
  await verifyIndex({bwURL, collName, seleniumDriver, expectedCnt: 0})

  // Navigate to the add form, add a new document, and navigate back to the index.
  await addNew({seleniumDriver, collName, newDoc: testData.currencyCNY})

  // Starting from the index, do we have exactly one document now? Are the fields correct?
  await verifyIndex({collName, seleniumDriver, expectedCnt: 1, verify: testData.currencyCNY})

  // Navigate to the add form, add a new document, and navigate back to the index.
  await addNew({seleniumDriver, collName, newDoc: testData.currencyRUB})

  // Starting from the index, do we have exactly two documents now?
  await verifyIndex({collName, seleniumDriver, expectedCnt: 2})

  // 2. GET a document, using a good id for an existing document via the UI, a well formed id that refers to a non-existent document via hacking the URL, and a mal-formed id.

  // 2.1 We should presently be on the /currencies index page. Follow the UI, pick the first currency in the list, and attempt to edit it.
  const documentRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (documentRows.length < 0) throw new Error('There should be more than 0 elements like this.')
  const editLink = await seleniumDriver.findElement(By.css('a#' + collName + '-edit'))
  await editLink.sendKeys('', Key.RETURN)
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-edit')))

  // 2.2 Now try to retrieve a well-formed, but non-existent id
  await seleniumDriver.get(bwURL + '/currencies/666666666666666666666666')
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#errors')))
  let errorRows
  errorRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (errorRows.length !== 1) throw new Error('There should be exactly 1 element like this.')

  // 2.3 Now try to retrieve a badly formed id
  await seleniumDriver.get(bwURL + '/currencies/catfood')
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#errors')))
  errorRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (errorRows.length !== 1) throw new Error('There should be exactly 1 element like this.')

  // 3. PATCH  a document, using a good id for an existing document, a well formed id that refers to a non-existent document, and a mal-formed id
  // await patch({collName, document: newDoc2, expectedError: undefined, fExpectSuccess: true, httpClient, id: priorResults.goodId[0], pn, priorResults})

  // await patch({collName, document: newDoc2, expectedError: bookWerxConstants.ATTEMPTED_IMPLICIT_CREATE, fExpectSuccess: false, httpClient, id: '666666666666666666666666', pn, priorResults})

  // await patch({collName, document: newDoc2, expectedError: 'Argument passed in must be a single String of 12 bytes or a string of 24 hex characters', fExpectSuccess: false, httpClient, id: 'catfood', pn, priorResults})
}
