module Misc exposing
    ( findAccountById
    , findCurrencyById
    )

import Types exposing (Account, AccountId, Currency, CurrencyId)
import RemoteData exposing (WebData)


findAccountById : AccountId -> WebData (List Account) -> Maybe Account
findAccountById accountId accounts =
    case RemoteData.toMaybe accounts of
        Just accounts ->
            accounts
                |> List.filter (\account -> account.id == accountId)
                |> List.head

        Nothing ->
            Nothing


findCurrencyById : CurrencyId -> WebData (List Currency) -> Maybe Currency
findCurrencyById currencyId currencies =
    case RemoteData.toMaybe currencies of
        Just currencies ->
            currencies
                |> List.filter (\currency -> currency.id == currencyId)
                |> List.head

        Nothing ->
            Nothing
