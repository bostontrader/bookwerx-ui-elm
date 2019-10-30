module Transaction.API.JSON exposing
    ( transactionDecoder
    , transactionsDecoder
    )

import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)
import Transaction.Transaction exposing (Transaction)


transactionsDecoder : Decoder (List Transaction)
transactionsDecoder =
    Json.Decode.list transactionDecoder


transactionDecoder : Decoder Transaction
transactionDecoder =
    Json.Decode.succeed Transaction
        |> required "id" int
        |> required "apikey" string
        |> required "notes" string
        |> required "time" string
