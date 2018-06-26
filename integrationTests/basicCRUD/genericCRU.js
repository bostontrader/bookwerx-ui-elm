const {By, Key, until} = require('selenium-webdriver')
const testData = require('bookwerx-testdata')

// Go to the index page of the collection and count the existing rows, if any.
const goHome = async ({bwURL, collName, seleniumDriver, expectedCnt}) => {
  await seleniumDriver.get(bwURL + '/' + collName)
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-index')))
  const documentRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (documentRows.length !== expectedCnt) throw new Error('There should be exactly ' + expectedCnt + ' elements like this.')
}

// Add a new document
const addNew = async ({seleniumDriver, newDoc}) => {
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
}

// Perform a basic CRU test
module.exports = async ({bwURL, collName, seleniumDriver}) => {
  let addLink

  // 1. Now read the documents collection and post new documents and demonstrate that we correctly have 0, 1, or 2 documents in the collection.

  // Go to the index.  Do we have exactly zero documents now?
  await goHome({bwURL, collName, seleniumDriver, expectedCnt: 0})

  // Find and follow the "{collName}/add" link
  await seleniumDriver.wait(until.elementLocated(By.css('a#' + collName + '-add')))
  addLink = await seleniumDriver.findElement(By.css('a#' + collName + '-add'))
  await addLink.sendKeys('', Key.RETURN)
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-add')))
  await seleniumDriver.findElement(By.css('div#' + collName + '-add'))

  // Add a new document
  await addNew({seleniumDriver, newDoc: testData.currencyCNY})

  // Go to the index.  Do we have exactly one document now?
  await goHome({bwURL, collName, seleniumDriver, expectedCnt: 1})

  // Find and follow the "{collName}/add" link
  await seleniumDriver.wait(until.elementLocated(By.css('a#' + collName + '-add')))
  addLink = await seleniumDriver.findElement(By.css('a#' + collName + '-add'))
  await addLink.sendKeys('', Key.RETURN)
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-add')))
  await seleniumDriver.findElement(By.css('div#' + collName + '-add'))

  // Add a new document
  await addNew({seleniumDriver, newDoc: testData.currencyRUB})

  // Go to the index.  Do we have exactly two documents now?
  await goHome({bwURL, collName, seleniumDriver, expectedCnt: 2})

  // 2. GET a document, using a good id for an existing document via the UI, a well formed id that refers to a non-existent document via hacking the URL, and a mal-formed id.

  // 2.1 We should presently be on the /currencies index page. Follow the UI, pick the first currency in the list, and attempt to edit it.
  const documentRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (documentRows.length <= 0) throw new Error('There should be more than 0 elements like this.')
  const editLink = await seleniumDriver.findElement(By.css('a#' + collName + '-edit'))
  await editLink.sendKeys('', Key.RETURN)
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-edit')))
  //await getOne({collName, expectedError: undefined, fExpectSuccess: true, httpClient, id: priorResults.goodId[0], pn, priorResults})

  // 2.2 Now try to retrieve a well-formed, but non-existent id
  await seleniumDriver.get(bwURL + '/currencies/666666666666666666666666')
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#errors')))
  let errorRows
  errorRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (errorRows.length !== 1) throw new Error('There should be exactly 1 elements like this.')
    //await getOne({collName, expectedError: 'currency 666666666666666666666666 does not exist', fExpectSuccess: false, httpClient, id: '666666666666666666666666', pn, priorResults})

  //await getOne({collName, expectedError: 'Argument passed in must be a single String of 12 bytes or a string of 24 hex characters', fExpectSuccess: false, httpClient, id: 'catfood', pn, priorResults})
  // 2.3 Now try to retrieve a badly formed id
  await seleniumDriver.get(bwURL + '/currencies/catfood')
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('div#errors')))
  errorRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (errorRows.length !== 1) throw new Error('There should be exactly 1 elements like this.')

}
