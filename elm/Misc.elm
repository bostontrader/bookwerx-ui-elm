module Misc exposing (findCurrencyById)

import Types exposing (Currency, CurrencyId)
import RemoteData exposing (WebData)

-- How can I test this?
findCurrencyById : CurrencyId -> WebData (List Currency) -> Maybe Currency
findCurrencyById currencyId currencies =
    case RemoteData.toMaybe currencies of
        Just currencies ->
            currencies
                |> List.filter (\currency -> currency.id == currencyId)
                |> List.head

        Nothing ->
            Nothing