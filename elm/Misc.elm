module Misc exposing
    ( findAccountById
    , findCategoryById
    , findCurrencyById
    , findTransactionById
    , insertFlashElement
    )

import RemoteData exposing ( WebData )
import TypesB exposing ( FlashMsg )


import Account.Plumbing exposing ( AccountId )
import Account.Account exposing ( Account )

import Category.Plumbing exposing ( CategoryId )
import Category.Category exposing ( Category )

import Currency.Plumbing exposing ( CurrencyId )
import Currency.Currency exposing ( Currency )

import Transaction.Plumbing exposing ( TransactionId )
import Transaction.Transaction exposing ( Transaction )


findAccountById : AccountId -> WebData (List Account) -> Maybe Account
findAccountById accountId accounts =
    case RemoteData.toMaybe accounts of
        Just accounts ->
            accounts
                |> List.filter (\account -> account.id == accountId)
                |> List.head

        Nothing ->
            Nothing


findCategoryById : CategoryId -> WebData (List Category) -> Maybe Category
findCategoryById categoryId categories =
    case RemoteData.toMaybe categories of
        Just categories ->
            categories
                |> List.filter (\category -> category.id == categoryId)
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


findTransactionById : TransactionId -> WebData (List Transaction) -> Maybe Transaction
findTransactionById transactionId transactions =
    case RemoteData.toMaybe transactions of
        Just transactions ->
            transactions
                |> List.filter (\transaction -> transaction.id == transactionId)
                |> List.head

        Nothing ->
            Nothing


--CreateFlashElement text color duration ->
insertFlashElement : List FlashMsg -> FlashMsg -> List FlashMsg
insertFlashElement flashMessages newFlashMsg =

    --let
        --expirationTime =
            --model.currentTime
                --+ (duration * Time.second)

    --    newFlashElement =
    --        { message = text
    --        , id = model.nextFlashId
    --        , expirationTime = expirationTime
    --        }


        --newList =
            newFlashMsg :: flashMessages
    --in
        --newList
        --{ model
            --| flashElements = newList
            -- | nextId = model.nextId + 1
        --}
           -- ! []
       --    ( model, Cmd.none )
