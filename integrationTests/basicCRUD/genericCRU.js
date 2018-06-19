const {By, Key, until} = require('selenium-webdriver')
const testData = require('bookwerx-testdata')

// Go to the index page of the collection and count the existing rows, if any.
const goHome = async ({bwURL, collName, seleniumDriver, expectedCnt}) => {
  await seleniumDriver.get(bwURL + '/' + collName)
  await seleniumDriver.wait(until.elementLocated(By.css('.loader')))
  await seleniumDriver.wait(until.elementLocated(By.css('#' + collName + '-index')))
  const documentRows = await seleniumDriver.findElements(By.css('tbody > tr'))
  if (documentRows.length !== expectedCnt) throw new Error('There should be exactly ' + expectedCnt + ' elements like this.')
}

// Add a new document
const addNew = async ({seleniumDriver, newDoc}) => {
  // 1. Enter a new symbol
  await seleniumDriver.wait(until.elementLocated(By.css('input#symbol')))
  const symbolInput = await seleniumDriver.findElement(By.css('input#symbol'))
  await symbolInput.sendKeys(testData.currencyCNY.symbol)

  // 2. Enter a new title
  await seleniumDriver.wait(until.elementLocated(By.css('input#title')))
  const titleInput = await seleniumDriver.findElement(By.css('input#title'))
  await titleInput.sendKeys(testData.currencyCNY.title)

  // 3. Save the new document
  await seleniumDriver.wait(until.elementLocated(By.css('button#save')))
  const saveButton = await seleniumDriver.findElement(By.css('button#save'))
  await saveButton.sendKeys('', Key.ENTER)
}

module.exports = async ({bwURL, collName, seleniumDriver}) => {
  let addLink

  // 0.  Go to the index.  Do we have exactly one document now?
  await goHome({bwURL, collName, seleniumDriver, expectedCnt: 0})

  // 1. Find and follow the "{collName}/add" link
  await seleniumDriver.wait(until.elementLocated(By.css('a#' + collName + '-add')))
  addLink = await seleniumDriver.findElement(By.css('a#' + collName + '-add'))
  await addLink.sendKeys('', Key.RETURN)
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-add')))
  await seleniumDriver.findElement(By.css('div#' + collName + '-add'))

  // 2. Add a new document
  await addNew({seleniumDriver, newDoc: testData.currencyCNY})

  // 3.  Go to the index.  Do we have exactly one document now?
  await goHome({bwURL, collName, seleniumDriver, expectedCnt: 1})

  // 4. Find and follow the "{collName}/add" link
  await seleniumDriver.wait(until.elementLocated(By.css('a#' + collName + '-add')))
  addLink = await seleniumDriver.findElement(By.css('a#' + collName + '-add'))
  await addLink.sendKeys('', Key.RETURN)
  await seleniumDriver.wait(until.elementLocated(By.css('div#' + collName + '-add')))
  await seleniumDriver.findElement(By.css('div#' + collName + '-add'))

  // 5. Add a new document
  await addNew({seleniumDriver, newDoc: testData.currencyRUB})

  // 6.  Go to the index.  Do we have exactly two documents now?
  await goHome({bwURL, collName, seleniumDriver, expectedCnt: 2})
}
