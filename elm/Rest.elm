--module Rest exposing (createCurrencyCommand, deleteCurrencyCommand, fetchCurrenciesCommand, updateCurrencyCommand, updateCurrencyRequest)
module Rest exposing (createCurrencyCommand, deleteCurrencyCommand, fetchCurrenciesCommand)

import Http
import RemoteData
--import Types exposing (Author, Msg(CurrencyCreated, CurrencyDeleted, CurrenciesReceived, CurrencyUpdated), Currency)
import Types exposing
    ( Currency
    , Msg
        ( CurrencyCreated
        , CurrencyDeleted
        , CurrenciesReceived
        )
    )

import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode

-- How can I test this?
currencyDecoder : Decoder Currency
currencyDecoder =
    decode Currency
        |> required "_id" string
        |> required "symbol" string
        |> required "title" string

-- How can I test this?
fetchCurrenciesCommand : Cmd Msg
fetchCurrenciesCommand =
    list currencyDecoder
        |> Http.get "http://localhost:3003/currencies"
        |> RemoteData.sendRequest
        |> Cmd.map CurrenciesReceived

{-updateCurrencyCommand : Currency -> Cmd Msg
updateCurrencyCommand currency =
    updateCurrencyRequest currency
        |> Http.send CurrencyUpdated

updateCurrencyRequest : Currency -> Http.Request Currency
updateCurrencyRequest currency =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:5019/currencies/" ++ (toString currency.id)
        , body = Http.jsonBody (currencyEncoder currency)
        , expect = Http.expectJson currencyDecoder
        , timeout = Nothing
        , withCredentials = False
        }

currencyEncoder : Currency -> Encode.Value
currencyEncoder currency =
    Encode.object
        [ ( "id", Encode.int currency.id )
        , ( "title", Encode.string currency.title )
        , ( "author", authorEncoder currency.author )
        ]


authorEncoder : Author -> Encode.Value
authorEncoder author =
    Encode.object
        [ ( "name", Encode.string author.name )
        , ( "url", Encode.string author.url )
        ] -}

deleteCurrencyCommand : Currency -> Cmd Msg
deleteCurrencyCommand currency =
    deleteCurrencyRequest currency
        |> Http.send CurrencyDeleted


deleteCurrencyRequest : Currency -> Http.Request String
deleteCurrencyRequest currency =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:3003/currencies/" ++ currency.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

createCurrencyCommand : Currency -> Cmd Msg
createCurrencyCommand currency =
    createCurrencyRequest currency
        |> Http.send CurrencyCreated

--createCurrencyRequest : Currency -> Http.Request Currency
--createCurrencyRequest currency =
    --Http.request
        --{ method = "POST"
        --, headers = []
        --, url = "http://localhost:3003/currencies"
        --, body = Http.jsonBody (newCurrencyEncoder currency)
        --, expect = Http.expectJson currencyDecoder
        --, timeout = Nothing
        --, withCredentials = False
        --}

createCurrencyRequest : Currency -> Http.Request Currency
createCurrencyRequest currency =
    Http.post
        "http://localhost:3003/currencies"
        (Http.jsonBody (newCurrencyEncoder currency)) currencyDecoder

newCurrencyEncoder : Currency -> Encode.Value
newCurrencyEncoder currency =
    Encode.object
        [ ( "symbol", Encode.string currency.symbol )
        , ( "title", Encode.string currency.title )
        ]
