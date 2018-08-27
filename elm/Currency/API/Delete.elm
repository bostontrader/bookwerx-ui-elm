-- API Level A.  See README.md
module Currency.API.Delete exposing ( deleteCurrencyCommand )

import Http

import Msg exposing ( Msg ( CurrencyMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CurrenciesDelete ) )

import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing ( CurrencyMsgB ( CurrencyDeleted ) )


deleteCurrencyCommand : Currency -> Cmd Msg
deleteCurrencyCommand currency =
    deleteCurrencyRequest currency
        |> Http.send CurrencyDeleted
        |> Cmd.map CurrencyMsgA


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
