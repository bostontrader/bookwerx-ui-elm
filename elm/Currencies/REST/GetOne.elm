-- REST Level C.  See README.md
module Currencies.REST.GetOne exposing ( getOneCurrencyCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Currencies.REST.JSON exposing
    ( getOneCurrencyDecoder
    , currencyEncoder
    )

import Types exposing
    ( Msg ( CurrencyReceived )
    , RouteProxied ( CurrenciesGetOne )
    , Currency
    )

getOneCurrencyCommand : String -> Cmd Msg
getOneCurrencyCommand currency_id =
    Cmd.map CurrencyReceived
        ( RemoteData.sendRequest
            ( Http.get ( ( extractUrlProxied CurrenciesGetOne ) ++ currency_id )  getOneCurrencyDecoder )
        )