--module Currencies.Rest exposing
--    ( createCurrencyCommand
--    , deleteCurrencyCommand
--    , fetchCurrenciesCommand
--    , fetchCurrencyCommand
--    , updateCurrencyCommand
--    )

--import Http
--import RemoteData

--import Types exposing
--    ( Msg
--        ( CurrencyCreated
--        , CurrencyDeleted
--        , CurrenciesReceived
--        , CurrencyReceived
--        , CurrencyUpdated
--        )
--    , Currency
--    , CurrencyEditHttpResponse(..)
--    )

--import Json.Decode exposing (Decoder, int, list, oneOf, string)
--import Json.Decode.Pipeline exposing (decode, required)
--import Json.Encode as Encode

--type alias CurrencyEditValidResponse = { data : Currency }

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


--currencyEditResponseDecoder : Json.Decode.Decoder CurrencyEditValidResponse
--currencyEditResponseDecoder =
--    Json.Decode.Pipeline.decode CurrencyEditValidResponse
--        |> Json.Decode.Pipeline.required "data" currencyDecoder

--validCurrencyEditDecoder : Decoder CurrencyEditHttpResponse
--validCurrencyEditDecoder =
--    Json.Decode.map
--        (\response -> ValidCurrencyEditResponse response.data)
--        currencyEditResponseDecoder

--errorCurrencyEditDecoder : Json.Decode.Decoder CurrencyEditHttpResponse
--errorCurrencyEditDecoder =
--    Json.Decode.map
--    (\response -> ErrorCurrencyEditResponse response.errors)
--    errorResponseDecoder


--currencyDecoderA : Decoder CurrencyEditHttpResponse
--currencyDecoderA =
--    Json.Decode.oneOf
--        [ validCurrencyEditDecoder
--        , errorCurrencyEditDecoder
--        ]

--currencyDecoder : Decoder Currency
--currencyDecoder =
--    decode Currency
--        |> required "_id" string
--        |> required "symbol" string
--        |> required "title" string


--fetchCurrenciesCommand : Cmd Msg
--fetchCurrenciesCommand =
--    list currencyDecoder
--        |> Http.get "http://localhost:3003/currencies"
--        |> RemoteData.sendRequest
--        |> Cmd.map CurrenciesReceived

--fetchCurrencyCommand : String -> Cmd Msg
--fetchCurrencyCommand currency_id =
--    currencyDecoderA
--        |> Http.get ("http://localhost:3003/currencies/" ++ currency_id)
--        |> RemoteData.sendRequest
--        |> Cmd.map CurrencyReceived

--updateCurrencyCommand : Currency -> Cmd Msg
--updateCurrencyCommand currency =
--    updateCurrencyRequest currency
--        |> Http.send CurrencyUpdated

--updateCurrencyRequest : Currency -> Http.Request Currency
--updateCurrencyRequest currency =
--    Http.request
--        { method = "PATCH"
--        , headers = []
--        , url = "http://localhost:3003/currencies/" ++ currency.id
--        , body = Http.jsonBody (currencyEncoder currency)
--        , expect = Http.expectJson currencyDecoder
--        , timeout = Nothing
--        , withCredentials = False
--        }

--currencyEncoder : Currency -> Encode.Value
--currencyEncoder currency =
--    Encode.object
--        [ ("id", Encode.string currency.id)
--        , ("symbol", Encode.string currency.symbol)
--        , ("title", Encode.string currency.title)
--        ]

--deleteCurrencyCommand : Currency -> Cmd Msg
--deleteCurrencyCommand currency =
--    deleteCurrencyRequest currency
--        |> Http.send CurrencyDeleted

--deleteCurrencyRequest : Currency -> Http.Request String
--deleteCurrencyRequest currency =
--    Http.request
--        { method = "DELETE"
--        , headers = []
--        , url = "http://localhost:3003/currencies/" ++ currency.id
--        , body = Http.emptyBody
--        , expect = Http.expectString
--        , timeout = Nothing
--        , withCredentials = False
--        }

--createCurrencyCommand : Currency -> Cmd Msg
--createCurrencyCommand currency =
--    createCurrencyRequest currency
--        |> Http.send CurrencyCreated

--createCurrencyRequest : Currency -> Http.Request Currency
--createCurrencyRequest currency =
--    Http.post
--        "http://localhost:3003/currencies"
--        (Http.jsonBody (newCurrencyEncoder currency)) currencyDecoder

--newCurrencyEncoder : Currency -> Encode.Value
--newCurrencyEncoder currency =
--    Encode.object
--        [ ( "symbol", Encode.string currency.symbol )
--        , ( "title", Encode.string currency.title )
--        ]
