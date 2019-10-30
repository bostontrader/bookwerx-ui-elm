[![Build Status](https://travis-ci.org/bostontrader/bookwerx-ui-elm.svg?branch=master)](https://travis-ci.org/bostontrader/bookwerx-ui-elm)
[![Known Vulnerabilities](https://snyk.io/test/github/bostontrader/bookwerx-ui-elm/badge.svg)](https://snyk.io/test/github/bostontrader/bookwerx-ui-elm)

[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Dependency Status](https://david-dm.org/bostontrader/bookwerx-ui-elm.svg)](https://david-dm.org/bostontrader/bookwerx-ui-elm)
[![devDependency Status](https://david-dm.org/bostontrader/bookwerx-ui-elm/dev-status.svg)](https://david-dm.org/bostontrader/bookwerx-ui-elm#info=devDependencies)

# Welcome to bookwerx-ui-elm

The purpose of **bookwerx-ui-elm** is to provide an example user interface, using Elm, to the [bookwerx-core-rust](https://github.com/bostontrader/bookwerx-core-rust) bookkeeping engine.

Said UI displays the actual HTTP commands sent to the server, as well as their responses.  **bookwerx-ui-elm** also provides a complete log of the same for an entire session.

# Getting started

## Prerequisits

* git
* node

The care and feeding of these things are beyond the scope of this document.  But assuming they are correctly installed...

## Clone

```bash
git clone https://github.com/bostontrader/bookwerx-ui-elm
cd bookwerx-ui-elm
npm install
```

## Test
Next, run the testing for the elm components.

```bash
npm test
```

## Dev Mode
Now try to use the app in development mode...

```bash
npm start
```
This will use the webpack-dev-server to serve the app on port 3005.  Using your browser of choice, browse to http://localhost:3005.  Be advised that webpack-dev-server is set to listen for connections from any IP address.

## Production Mode
Finally, build the production artifacts.  These are the index.html file that launches the app, as well as associated JS, CSS, and images.


```bash
npm run prod
```

Please find these artifacts in the /dist directory.  Copy them to your webserver of choice and you're good to go!


# Digger Deeper...


## Berver

Recall that this app is primarily a UI created as a tool of pedagogery to enable the user to study the API of **bookwerx-core-rust**  So the first step is to figure out which bookwerx-core server to connect to and use.

You can use our hardwired public demonstration server or change that URL to another server that you might know about. Either way you'll need to test the connection before you can proceed.


## HTTP Logging

All of the HTTP traffic between the UI and the **bookwerx-core-rust** server is available for inspection in the HTTP Panel.  In addition, many windows display the http request being constructed, as the user makes changes in the UI, as well as the ultimate response from the server.

In this way, we hope the user can gain understanding and insight into the operation of the API.


## Public demonstration server

Please realize that the hardwired public demonstration **bookwerx-core-rust** server is exactly that.  It's public, it's not very high performant, and it may be brainwiped at any time.  You don't know who we are, we don't have a privacy policy, and you don't know our neferious intentions with your highly confidential data.

So please enjoy the public demonstration but think carefully about this before you put this to more important use.  In fact, for production use, you'd probably want to setup your own private **bookwerx-core-rust** server.

## API Key

All of the API calls include an API key.  **bookwerx-ui-elm** will enable you to request a new API key or to re-use an existing key that you already have.

Please realize that if you lose your API key you lose all access to your data and that a new API key will only let you start over.


## Currencies

The first step in our path to the multi-currency nirvana is to define the currencies that are relevant to our use.  "Currencies" being generously defined to included conventional fiat "money" as well as crypto-coins, precious metals, tobacco leaves, muskrat skins, slave girls, or whatever else looks like a currency in your app.


## Sum DR != Sum CR

The secret to doing multi-currency bookkeeping is to simply drop the traditional constraint that the sum of the debits must equal the sum of the credits.  Conceptually that still holds, but the actual numbers involved no longer satisfy that constraint.  Whatever error checking the conventional system provides must therefore be provided in some other way.

For example: DR 500 Quatloos, CR 15 General Atomic Sheckles would violate the original constraint, but works just fine here.  Looks like a currency exchange to me, and the motivated reader is encouraged to calculate the implied exchange rate.


## Accounts and Categories

You already know what accounts are.  In addition to these accounts **bookwerx-ui-elm** will also enable you to manage a collection of "categories".  For example "assets" and "revenue" are two obvious categories that are commonly relevant to this topic, and the user is encouraged to create as many categories as desired.  

Each account can be tagged with zero or more categories.  This is most useful for reporting because we frequently want subsets of accounts when doing so.


## Rarity

It's easy to accumulate a long list of currencies that have appeared in any transaction in the past, most of which are no longer relevant.  When entering new transactions, we may not want to wade through hundreds of rarely used currencies, just to find the one we want now.

We also don't want a simple flag on the currency that indicates hide/show because there are plenty of currencies that might be rarely used, but still occasionally used.  Hence the concept of "rarity".

Each currency can be tagged with an integer rarity and said rarity can power a filter in the UI.  Use it or not, but it's there.

Rarity also applies to accounts, for the same reasons, and works the same way.


## Transactions and Distributions

You already have an intuitive grasp of what a transaction is.  **bookwerx-ui-elm** certainly enables the user to manage them.

A transaction has zero or more "distributions."  That is, the lines of debits and credits.


## Formatting Debits and Credits

When dealing with debits and credits we have two basic choices:

* When entering distributions we enter all amounts as positive and select DR or CR as necessary.  Any UI that displays this information will also display DR and CR.

* When entering distributions use positive numbers to indicate DR and negative numbers for CR.  Any UI that displays this information will simply display the number as is, without any DR and CR.  The user may infer DR and CR from the numeric sign.

**bookwerx-core-rust** stores these numbers internally and communicates them via the API using the latter style and some people are cool with this.  Other people want to see their DR and CR or they get agitated.  Either way works for the UI.


## Numbers

When dealing with money we don't want round-off errors.  So instead we use two integers and scientific notation to represent any amount.

This is how the numbers are stored internally and communicated via the API.  This is admittedly a nuisance from the UI point of view, but all numbers are conveniently formatted upon display.  The user can also adjust the quantity of decimal places to display and **bookwerx-ui-elm** will provide feedback to tell you if any round-off error is hidden by insufficient decimal display.


## Time

The concept of time is a bottomless pit of complexity.  Nevertheless, we must still make practical usage of it when entering transactions.  Therefore the rules are:

A transaction happens at an instant in time.  This time can be described by using any string format that is suitable for your application, provided that the alphabetical sort of these strings lists the times in increasing temporal order.  ISO-8601 format is reasonable choice to get started.


## Reports

**bookwerx-ui-elm** provides a rudimentary reporting feature.  There are so many variations of what "reporting" might mean that it would be hopeless to try to make something that everybody loves, or perhaps anybody loves.  

The fundamental goal in reporting is to determine the balance of an account as of a particular date (a stock) or the amount that an account has changed during a time period (a flow). Building on that we want to do the same for any particular category of accounts.

Conceptually, this is very easy to do.  Ask the API to provide a list of _all_ distributions, and then filter, fold, map, fiddle with recursion or whatever it takes to gyrate the data into a format that you like.  In fact, that's basically what we do.  API only provides distributions and its the UI's responsibility to figure out how to present this info.


## Linting

There are a variety of conditions that the pedantic reader might fret about.  Such as currencies or accounts that are not used, transactions that have zero distributions, and so on. Although harmless, their mere existance will doubtlessly disturb your sleep.  Crank up the linter and put these things out of your misery.


## I18N

Most of the UI has translations for Chinese and Pinyin.  This is mostly to demonstrate the ability to change the UI language, on the fly, via a setting.

## Basic Architecture

This is a single-page app written in Elm.  Our goal is to take the provided source code and build some artifacts that can be served via http.  There be devils in those details.  More particularly...

The artifacts that we want are:

index.html, index.js, favicon.ico, and some images.

We're using webpack for this, combined with copius inspiration from [elm-webpack-starter](https://github.com/simonh1000/elm-webpack-starter)

During development, we use the webpack-dev-server.  It does all the webpacky things, but doesn't actually write the artifacts out.  In order to get the artifacts we want, we need to build for production (using npm run prod)  We can then copy said artifacts to an http server and just serve 'em up.

src/index.html is a template and src/index.js contains the js logic to get the ball rolling.  webpack.config.js figures out what to do with these things and how to hook 'em together.

There are no CSS files because all of this is handled by webpack and JS.

/src/assets contains whatever images or other static files that we have and webpack copies these things to /dist

