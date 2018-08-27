module Account.Model exposing ( Model )

import RemoteData exposing (WebData)

import Account.Plumbing exposing ( AccountGetOneHttpResponse )
import Account.Account exposing (Account)

type alias Model =
    { accounts : WebData (List Account)
    , wdAccount : WebData AccountGetOneHttpResponse
    , editAccount : Account
    }