module Currency.Model exposing (Model)

import Currency.Currency exposing (Currency)
import IntField exposing (IntField(..))
import RemoteData exposing (WebData)


type alias Model =
    -- wdCurrencies is the 4 state RemoteData response from GetMany.  If the response is "success" the response is a raw string that shall be decoded as a List of Currency and stored in currencies, -or- if it cannot be decoded it shall be assumed to be an error reported from the server.
    { currencies : List Currency -- JSON decoded from wdCurrencies
    , wdCurrencies : WebData String -- the raw string response from GetMany
    , wdCurrency : WebData String
    , editBuffer : Currency
    }
