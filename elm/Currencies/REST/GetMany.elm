-- REST Level B.  See README.md
module Currencies.REST.GetMany exposing ( getManyCurrenciesCommand )

import Http
import RemoteData
import Json.Decode exposing ( list )

import Routing exposing ( extractUrlProxied )
import Currencies.REST.JSON exposing ( currencyDecoder )
import Types exposing
    ( Msg ( CurrenciesReceived )
    , RouteProxied ( CurrenciesGetMany )
    , Currency
    )

getManyCurrenciesCommand : Cmd Msg
getManyCurrenciesCommand =
    list currencyDecoder
        |> Http.get ( extractUrlProxied CurrenciesGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map CurrenciesReceived
