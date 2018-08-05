module Transactions.REST.Rest exposing (..)
--    ( createTransactionCommand
--    , deleteTransactionCommand
--    , fetchTransactionCommand
    -- , getManyTransactionsCommand
--    , patchTransactionCommand
--    )

--import Http
--import RemoteData
--import Json.Decode exposing (Decoder)
--import Types exposing
--    ( Msg
--        ( TransactionCreated
--        , TransactionDeleted
--        , TransactionsReceived
--        , TransactionReceived
--        , TransactionPatched
--        )
--    , Transaction
--    , TransactionEditHttpResponse(..)
--    , TransactionPatchHttpResponse(..)
--    )

--import Json.Decode exposing (Decoder, int, list, oneOf, string)
--import Json.Decode.Pipeline exposing (decode, required)
--import Json.Encode as Encode

--type alias TransactionEditValidResponse = { data : Transaction }
--type alias TransactionPatchValidResponse = { data : Transaction }

--type alias Error =
--    { key : String, value : String }

--type alias ErrorResponse =
--    { errors : List Error }

--errorDecoder : Json.Decode.Decoder Error
--errorDecoder =
--    Json.Decode.Pipeline.decode Error
--        |> Json.Decode.Pipeline.required "key" Json.Decode.string
--        |> Json.Decode.Pipeline.required "value" Json.Decode.string

--errorListDecoder : Json.Decode.Decoder (List Error)
--errorListDecoder =
--    Json.Decode.list errorDecoder

--errorResponseDecoder : Json.Decode.Decoder ErrorResponse
--errorResponseDecoder =
--    Json.Decode.Pipeline.decode ErrorResponse
--        |> Json.Decode.Pipeline.required "errors" errorListDecoder


--transactionEditResponseDecoder : Json.Decode.Decoder TransactionEditValidResponse
--transactionEditResponseDecoder =
--    Json.Decode.Pipeline.decode TransactionEditValidResponse
--        |> Json.Decode.Pipeline.required "data" transactionDecoder

--transactionPatchResponseDecoder : Json.Decode.Decoder TransactionPatchValidResponse
--transactionPatchResponseDecoder =
--    Json.Decode.Pipeline.decode TransactionPatchValidResponse
--        |> Json.Decode.Pipeline.required "data" transactionDecoder

--validTransactionEditDecoder : Decoder TransactionEditHttpResponse
--validTransactionEditDecoder =
--    Json.Decode.map
--        (\response -> ValidTransactionEditResponse response.data)
--        transactionEditResponseDecoder

--validTransactionPatchDecoder : Decoder TransactionPatchHttpResponse
--validTransactionPatchDecoder =
--    Json.Decode.map
--        (\response -> ValidTransactionPatchResponse response.data)
--        transactionPatchResponseDecoder

--errorTransactionEditDecoder : Json.Decode.Decoder TransactionEditHttpResponse
--errorTransactionEditDecoder =
--    Json.Decode.map
--    (\response -> ErrorTransactionEditResponse response.errors)
--    errorResponseDecoder

--errorTransactionPatchDecoder : Json.Decode.Decoder TransactionPatchHttpResponse
--errorTransactionPatchDecoder =
--    Json.Decode.map
--    (\response -> ErrorTransactionPatchResponse response.errors)
--    errorResponseDecoder

--transactionDecoderA : Decoder TransactionEditHttpResponse
--transactionDecoderA =
--    Json.Decode.oneOf
--        [ validTransactionEditDecoder
--        , errorTransactionEditDecoder
--        ]

--transactionDecoder : Decoder Transaction
--transactionDecoder =
--    decode Transaction
--        |> required "_id" string
--        |> required "datetime" string
--        |> required "note" string

--patchTransactionDecoder : Decoder TransactionPatchHttpResponse
--patchTransactionDecoder =
--    Json.Decode.oneOf
--        [ validTransactionPatchDecoder
--        , errorTransactionPatchDecoder
--        ]

--getManyTransactionsCommand : Cmd Msg
--getManyTransactionsCommand =
--    list transactionDecoder
--        |> Http.get "http://localhost:3003/transactions"
--        |> RemoteData.sendRequest
--        |> Cmd.map TransactionsReceived

--fetchTransactionCommand : String -> Cmd Msg
--fetchTransactionCommand transaction_id =
--    Cmd.map TransactionReceived
--        (RemoteData.sendRequest
--            (Http.get ("http://localhost:3003/transactions/" ++ transaction_id) transactionDecoderA))
--    transactionDecoderA
--        |> Http.get ("http://localhost:3003/transactions/" ++ transaction_id)
--        |> RemoteData.sendRequest
--        |> Cmd.map TransactionReceived

--updateTransactionCommand : Transaction -> Cmd Msg
--updateTransactionCommand transaction =
--    updateTransactionRequest transaction
--        |> Http.send TransactionUpdated

--patchTransactionCommand : Transaction -> Cmd Msg
--patchTransactionCommand transaction =
--    Cmd.map TransactionPatched
--        (RemoteData.sendRequest
            --(Http.get "http://localhost:3003/transactions/" patchTransactionDecoder)
--            (patcher transaction patchTransactionDecoder)
--        )

        --Http.request
        --   { method = "PATCH"
        --            , headers = []
        --            , url = "http://localhost:3003/transactions/" ++ transaction.id
        --            , body = Http.jsonBody (transactionEncoder transaction)
        --            , expect = Http.expectJson transactionDecoder
        --            , timeout = Nothing
        --            , withCredentials = False
        --            })

--patcher : Transaction -> Json.Decode.Decoder a -> Http.Request a
--patcher transaction decoder =
--    Http.request
--        { method = "PATCH"
--        , headers = []
--        , url = "http://localhost:3003/transactions/" ++ transaction.id
--        , body = Http.jsonBody (transactionEncoder transaction)
--        , expect = Http.expectJson decoder
--        , timeout = Nothing
--        , withCredentials = False
--        }

    --updateTransactionDecoder
    --    |> Http.request
    --        { method = "PATCH"
    --        , headers = []
    --        , url = "http://localhost:3003/transactions/" ++ transaction.id
    --        , body = Http.jsonBody (transactionEncoder transaction)
    --        , expect = Http.expectJson transactionDecoder
    --        , timeout = Nothing
    --        , withCredentials = False
    --        }
    --    |> RemoteData.sendRequest

--updateTransactionRequest : Transaction -> Http.Request Transaction
--updateTransactionRequest transaction =
--    Http.request
--        { method = "PATCH"
--        , headers = []
--        , url = "http://localhost:3003/transactions/" ++ transaction.id
--        , body = Http.jsonBody (transactionEncoder transaction)
--        , expect = Http.expectJson transactionDecoder
--        , timeout = Nothing
--        , withCredentials = False
--        }

--transactionEncoder : Transaction -> Encode.Value
--transactionEncoder transaction =
--    Encode.object
--        [ ("id", Encode.string transaction.id)
--        , ("datetime", Encode.string transaction.datetime)
--        , ("note", Encode.string transaction.note)
--        ]

--deleteTransactionCommand : Transaction -> Cmd Msg
--deleteTransactionCommand transaction =
--    deleteTransactionRequest transaction
--        |> Http.send TransactionDeleted

--deleteTransactionRequest : Transaction -> Http.Request String
--deleteTransactionRequest transaction =
--    Http.request
--        { method = "DELETE"
--        , headers = []
--        , url = "http://localhost:3003/transactions/" ++ transaction.id
--        , body = Http.emptyBody
--        , expect = Http.expectString
--        , timeout = Nothing
--        , withCredentials = False
--        }

--createTransactionCommand : Transaction -> Cmd Msg
--createTransactionCommand transaction =
--    createTransactionRequest transaction
--        |> Http.send TransactionCreated

--createTransactionRequest : Transaction -> Http.Request Transaction
--createTransactionRequest transaction =
--    Http.post
--        "http://localhost:3003/transactions"
--        (Http.jsonBody (Debug.log "Rest createTransactionRequest" (newTransactionEncoder transaction))) transactionDecoder

--newTransactionEncoder : Transaction -> Encode.Value
--newTransactionEncoder transaction =
--    Encode.object
--        [ ( "datetime", Encode.string transaction.datetime )
--        , ( "note", Encode.string transaction.note )
--        ]
