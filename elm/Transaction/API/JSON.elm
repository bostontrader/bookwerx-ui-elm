module Transaction.API.JSON exposing
    ( transactionDecoder
    , transactionEncoder
    )

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Transaction.Transaction exposing ( Transaction )


transactionEncoder : Transaction -> Encode.Value
transactionEncoder transaction =
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
