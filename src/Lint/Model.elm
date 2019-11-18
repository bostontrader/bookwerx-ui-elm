module Lint.Model exposing (Model)

import Lint.Lint exposing (Lint)
import RemoteData exposing (WebData)


type alias Model =
    { lints : List Lint -- JSON decoded from wdAccounts
    , wdLints : WebData String -- the raw string http response
    , linter : String -- A string representation of the particular linter in use.
    }
