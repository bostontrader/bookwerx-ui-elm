module Transactions.REST.JSON exposing
    ( getOneTransactionDecoder
    , patchTransactionDecoder
    , postTransactionDecoder
    , transactionDecoder
    , transactionEncoder, newTransactionEncoder
    , transactionPatchResponseDecoder
    )

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Types exposing
    ( errorResponseDecoder
    , Transaction
    , TransactionPostHttpResponse(..)
    , TransactionPatchHttpResponse(..)
    )

transactionEncoder : Transaction -> Encode.Value
transactionEncoder transaction =
    Encode.object
        [ ("id", Encode.string transaction.id)
        , ("datetime", Encode.string transaction.datetime)
        , ("note", Encode.string transaction.note)
        ]

newTransactionEncoder : Transaction -> Encode.Value
newTransactionEncoder transaction =
    Encode.object
        [ ( "datetime", Encode.string transaction.datetime )
        , ( "note", Encode.string transaction.note )
        ]

transactionDecoder : Decoder Transaction
transactionDecoder =
    decode Transaction
        |> required "_id" string
        |> required "datetime" string
        |> required "note" string

-- getOne
getOneTransactionDecoder : Decoder TransactionPostHttpResponse
getOneTransactionDecoder =
    Json.Decode.oneOf
        [ validTransactionEditDecoder
        , errorTransactionEditDecoder
        ]

validTransactionEditDecoder : Decoder TransactionPostHttpResponse
validTransactionEditDecoder =
    Json.Decode.map
        (\response -> ValidTransactionPostResponse response.data)
        transactionEditResponseDecoder

errorTransactionEditDecoder : Json.Decode.Decoder TransactionPostHttpResponse
errorTransactionEditDecoder =
    Json.Decode.map
    (\response -> ErrorTransactionPostResponse response.errors)
    errorResponseDecoder

transactionEditResponseDecoder : Json.Decode.Decoder TransactionEditValidResponse
transactionEditResponseDecoder =
    Json.Decode.Pipeline.decode TransactionEditValidResponse
        |> Json.Decode.Pipeline.required "data" transactionDecoder

type alias TransactionEditValidResponse = { data : Transaction }

-- patch
patchTransactionDecoder : Decoder TransactionPatchHttpResponse
patchTransactionDecoder =
    Json.Decode.oneOf
        [ validTransactionPatchDecoder
        , errorTransactionPatchDecoder
        ]

validTransactionPatchDecoder : Decoder TransactionPatchHttpResponse
validTransactionPatchDecoder =
    Json.Decode.map
        (\response -> ValidTransactionPatchResponse response.data)
        transactionPatchResponseDecoder

transactionPatchResponseDecoder : Json.Decode.Decoder TransactionPatchValidResponse
transactionPatchResponseDecoder =
    Json.Decode.Pipeline.decode TransactionPatchValidResponse
        |> Json.Decode.Pipeline.required "data" transactionDecoder

errorTransactionPatchDecoder : Json.Decode.Decoder TransactionPatchHttpResponse
errorTransactionPatchDecoder =
    Json.Decode.map
    (\response -> ErrorTransactionPatchResponse response.errors)
    errorResponseDecoder

type alias TransactionPatchValidResponse = { data : Transaction }


-- post
--postTransactionDecoder
--resultDecoder : Decoder PostTransactionResult
--resultDecoder =
--    decode PostTransactionResult
--        |> required "n" int
--        |> required "ok" int
postTransactionDecoder : Decoder TransactionPostHttpResponse
postTransactionDecoder =
    Json.Decode.oneOf
        [ validTransactionPostDecoder
        , errorTransactionPostDecoder
        ]

validTransactionPostDecoder : Decoder TransactionPostHttpResponse
validTransactionPostDecoder =
    Json.Decode.map
        (\response -> ValidTransactionPostResponse response.data)
        transactionPostResponseDecoder

transactionPostResponseDecoder : Json.Decode.Decoder TransactionPostValidResponse
transactionPostResponseDecoder =
    Json.Decode.Pipeline.decode TransactionPostValidResponse
        |> Json.Decode.Pipeline.required "data" transactionDecoder

errorTransactionPostDecoder : Json.Decode.Decoder TransactionPostHttpResponse
errorTransactionPostDecoder =
    Json.Decode.map
    (\response -> ErrorTransactionPostResponse response.errors)
    errorResponseDecoder

type alias TransactionPostValidResponse = { data : Transaction }
