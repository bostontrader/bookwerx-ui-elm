module Transaction.Plumbing exposing
    ( TransactionId
    , TransactionGetOneHttpResponse(..)
    , TransactionPatchHttpResponse(..)
    , TransactionPostHttpResponse(..)
    , PostTransactionResponse
    )

import RemoteData exposing ( WebData )

import TypesB exposing ( BWCore_Error, FlashMsg )

import Transaction.Transaction exposing ( Transaction )


type alias TransactionId = String

type TransactionGetOneHttpResponse
    = TransactionGetOneDataResponse Transaction
    | TransactionGetOneErrorsResponse (List BWCore_Error)

type TransactionPatchHttpResponse
    = TransactionPatchDataResponse Transaction
    | TransactionPatchErrorsResponse (List BWCore_Error)

type TransactionPostHttpResponse
    = TransactionPostDataResponse PostTransactionResponse
    | TransactionPostErrorsResponse (List BWCore_Error)

type alias PostTransactionResponse = { insertedId : String }
