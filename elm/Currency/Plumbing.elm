module Currency.Plumbing exposing
    ( CurrencyId
    , CurrencyGetOneHttpResponse(..)
    , CurrencyPatchHttpResponse(..)
    , CurrencyPostHttpResponse(..)
    , PostCurrencyResponse
    )

import RemoteData exposing ( WebData )

import TypesB exposing ( BWCore_Error, FlashMsg )

import Currency.Currency exposing ( Currency )


type alias CurrencyId = String

type CurrencyGetOneHttpResponse
    = CurrencyGetOneDataResponse Currency
    | CurrencyGetOneErrorsResponse (List BWCore_Error)

type CurrencyPatchHttpResponse
    = CurrencyPatchDataResponse Currency
    | CurrencyPatchErrorsResponse (List BWCore_Error)

type CurrencyPostHttpResponse
    = CurrencyPostDataResponse PostCurrencyResponse
    | CurrencyPostErrorsResponse (List BWCore_Error)

type alias PostCurrencyResponse = { insertedId : String }
