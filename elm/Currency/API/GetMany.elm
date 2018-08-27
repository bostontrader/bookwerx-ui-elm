-- API Level B.  See README.md
module Currency.API.GetMany exposing ( getManyCurrenciesCommand )

import Http
import Json.Decode exposing ( list )
import RemoteData

import Msg exposing ( Msg ( CurrencyMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CurrenciesGetMany ) )

import Currency.API.JSON exposing ( currencyDecoder )
import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing ( CurrencyMsgB ( CurrenciesReceived ) )


getManyCurrenciesCommand : Cmd Msg
getManyCurrenciesCommand =
    list currencyDecoder
        |> Http.get ( extractUrlProxied CurrenciesGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map CurrenciesReceived
        |> Cmd.map CurrencyMsgA
