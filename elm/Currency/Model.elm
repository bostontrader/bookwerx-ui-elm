module Currency.Model exposing ( Model )

import RemoteData exposing (WebData)

import Currency.Plumbing exposing ( CurrencyGetOneHttpResponse )
import Currency.Currency exposing (Currency)

type alias Model =
    { currencies : WebData (List Currency)
    , wdCurrency : WebData CurrencyGetOneHttpResponse
    , editCurrency : Currency
    }