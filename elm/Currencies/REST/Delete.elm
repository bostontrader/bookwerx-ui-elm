-- REST Level A.  See README.md
module Currencies.REST.Delete exposing ( deleteCurrencyCommand )

import Http

import Routing exposing ( extractUrlProxied )
import Types exposing
    ( Msg ( CurrencyDeleted )
    , RouteProxied ( CurrenciesDelete )
    , Currency
    )


deleteCurrencyCommand : Currency -> Cmd Msg
deleteCurrencyCommand currency =
    deleteCurrencyRequest currency
        |> Http.send CurrencyDeleted


deleteCurrencyRequest : Currency -> Http.Request String
deleteCurrencyRequest currency =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = ( extractUrlProxied CurrenciesDelete ) ++ currency.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
