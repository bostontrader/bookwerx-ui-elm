[![Build Status](https://travis-ci.org/bostontrader/bookwerx-ui-elm.svg?branch=master)](https://travis-ci.org/bostontrader/bookwerx-ui-elm)
[![Coverage Status](https://coveralls.io/repos/github/bostontrader/bookwerx-ui-elm/badge.svg?branch=react)](https://coveralls.io/github/bostontrader/bookwerx-ui?branch=react)
[![Known Vulnerabilities](https://snyk.io/test/github/bostontrader/bookwerx-ui-elm/badge.svg)](https://snyk.io/test/github/bostontrader/bookwerx-ui-elm)

[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Dependency Status](https://david-dm.org/bostontrader/bookwerx-ui-elm.svg)](https://david-dm.org/bostontrader/bookwerx-ui-elm)
[![devDependency Status](https://david-dm.org/bostontrader/bookwerx-ui-elm/dev-status.svg)](https://david-dm.org/bostontrader/bookwerx-ui-elm#info=devDependencies)

# Welcome to bookwerx-ui-elm

The purpose of **bookwerx-ui-elm** is to provide an example user interface, using Elm, to the [bookwerx-core](https://github.com/bostontrader/bookwerx-core) bookkeeping engine.  This package provides a server that the actual user interacts with.  Said server than relays requests and responses to and from the **bookwerx-core** backend.

# Getting started

```bash
git clone https://github.com/bostontrader/bookwerx-ui-elm
cd bookwerx-ui-elm
npm install
```

Next, run the testing for the elm components.  Doing so will automatically download required elm packages.

```bash
cd elm
npx elm-test
cd ..
```

We use webpack, but not the dev server.  We need to run webpack the first time to create the bundle, and then we need to do this again whenever we change any of the relevant code.  Feel free to make webpack do fancy tricks on your own.

```bash
npx webpack
```

Next, study the section on **runtime configuration** so that you are properly in control of your configurations.  Using this [new learning](https://www.youtube.com/watch?v=9D5_V72jMtM&t=1323), tweak the following example as necessary:

Note: Be sure you have a **bookwerx-core** server, that is suitable for testing, at this configured location!

```bash
BW_MODE=test BW_PORT=3004 BWCORE_URL=http://127.0.0.1:3003 BWUI_DOMAIN=localhost node integrationTest.js
```

Be sure that BWCORE_URL points to a functioning **bookwerx-core** server.

Next, tweak package.json scripts.start, as necessary.  And then:

```bash
npm start
```

Watch the console and you'll see a message telling you what port the server is listening to.

Finally, you'll need a set of API Keys in order to use the API.  Please review the **API** section for this.


## Runtime Configuration

Runtime configuration is provided via environment variables. There are no other defaults and if these variables are missing or not correctly set, then the server will probably not do anything useful.  These parameters can be fed to node on the command line.  See package.json scripts.start for an example to start the server in "development" mode.


The following env variables are used by **bookwerx-ui-elm**:

* BWUI_MODE - Which operating mode shall we use? Any string is suitable but test, development, and production are customary.

* BWUI_PORT - Which port shall **bookwerx-ui-elm** listen to?

* BWCORE_URL - The url for the **bookwerx-core** server.  This means 'http://' and hostname and port.

In addition to the above, in order for testing to work we need:

* BWUI_URL - The url for the **bookwerx-ui-elm** server to test.  This means 'http://' and hostname and port.

# Basic Architecture

Although it's possible to write a rudimentary server using only Elm and (elm-react or elm-live), these tools are only suitable for beginner projects and have various limitiations too numerous and tedious to enumerate here, so we need stronger tools.  That said, and considering that Elm transpiles to Javascript, this application is architected as follows:

1. The app is a Single Page Application,  aka SPA.

2. We use restify to provide the HTTP server.  The server will serve a small fragment of HTML that links to a lump o' Javascript as created by webpack.  Webpack enables us to integrate Elm (via transpilation) and Javascript, as well as all the other goodies such as access to CSS.

# Testing

There are two basic elements of testing:

1. A suite of unit-testing level tests using Elm.

2. An integration test using Javascript.  This test will start with an empty db and make a long sequence of CRUD operations intended to verify correct behavior.

Integration testing needs a real **bookwerx-core** server so be sure to provide one.  Each run of integration testing will specify a database name that contains the present time.  In this way, each run will start with a fresh and empty db, enabling us to avoid the problem of trying to reset the db.  The **bookwerx-core** server needs to be running in development mode to enable this behavior.

Other testing such as testing that the server starts, what error messages it emits, how it reacts to errors, whether or not it properly connects to the Elm code, etc.,  as well as test coverage generally, are hereby deemed to be not important enough to directly test.

The fact that the server starts and is able to serve HTML that connects to the transpiled Elm code is indisputably established if the main testing succeeds.  Whatever error messages and reactions to errors the server emits are only clues to solving whatever underlying problem is has.  If the main tests succeed, then obviously there's no underlying problem, so the value in tediously testing these things is minimal.

Regarding test coverage: Given TDD, the testing will cover what we want done.  As errors are found, the screws get tightened.  This will automatically increase test coverage, even if said coverage is not specially measured.  That's good enough in this context.




# On require vs import
`
There exists a giant can of worms re: using the 'require' statement vs the 'import' statement.  The bottom line, IMHO, is that the 'import' statement, although shiny, new, and modern, just doesn't earn its keep.  Everybody else in the world already uses 'require' and that works well enough, especially in this particular context. At this time, the 'import' statement is not very well supported and requires too many contortions to use.  All this and for what benefit?  So we can load modules asynchonously? Homey don't play that.

# Dependencies

* restify - This is the server.

# devDependencies

* bookwerx-testdata

* bulma - css framework

* css-loader - Webpack needs this for css.

* cypress - Testing.

* elm-test - Use this to launch the elm testing.

* elm-webpack-loader

* file-loader - Webpack uses this to load .html

* mongodb - Need this to connect directly to an underlying mongodb in order to brainwipe.

* standard - Code linter

* style-loader - Webpack needs this for css.

* webpack

* webpack-cli
