[![Build Status](https://travis-ci.org/bostontrader/bookwerx-ui-elm.svg?branch=master)](https://travis-ci.org/bostontrader/bookwerx-ui-elm)
[![Coverage Status](https://coveralls.io/repos/github/bostontrader/bookwerx-ui-elm/badge.svg?branch=react)](https://coveralls.io/github/bostontrader/bookwerx-ui?branch=react)
[![Known Vulnerabilities](https://snyk.io/test/github/bostontrader/bookwerx-ui-elm/badge.svg)](https://snyk.io/test/github/bostontrader/bookwerx-ui-elm)

[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Dependency Status](https://david-dm.org/bostontrader/bookwerx-ui-elm.svg)](https://david-dm.org/bostontrader/bookwerx-ui-elm)
[![devDependency Status](https://david-dm.org/bostontrader/bookwerx-ui-elm/dev-status.svg)](https://david-dm.org/bostontrader/bookwerx-ui-elm#info=devDependencies)

# Welcome to bookwerx-ui-elm

The purpose of **bookwerx-ui-elm** is to provide an example user interface, using Elm, to the [bookwerx-core](https://github.com/bostontrader/bookwerx-core) bookkeeping engine.  This package provides a server that the actual user interacts with.  Said server than relays requests and responses to and from the **bookwerx-core** backend.

# Getting Started

I wish I could tell you **npm install** and you're good to go.  Instead, we have a multi-step ramp up process whereby we find the various dependencies that we will need and to establish various types of service and testing, in our ultimate attempt to put this to use.

```sh
$ npm install
```


## Runtime Configuration

Runtime configuration is provided via environment variables. There are no other defaults and if these variables are not correctly set, then the server will probably not do anything useful.  These parameters can be fed to node on the command line.  See package.json scripts.start for an example to start the server in "development" mode and scripts.test for an example to start the server in "test" mode.

The following env variables are used by **bookwerx-ui-elm**:

* MODE - Which operating mode shall we use?  test? development? production?

* BW_PORT - Which port shall **bookwerx-ui-elm** listen to?

* BWCORE_URL - The url and port for the **bookwerx-core** server.

# On require vs import

There exists a giant can of worms re: using the 'require' statement vs the 'import' statement.  The bottom line, IMHO, is that the 'import' statement, although shiny, new, and modern, just doesn't earn its keep.  Everybody else in the world already uses 'require' and that works well enough, especially in this particular context. At this time, the 'import' statement is not very well supported and requires too many contortions to use.  All this and for what benefit?  So we can load modules asynchonously? Homey don't play that.

# Dependencies

* restify - This is the server.

# devDependencies

* standard - Code linter

