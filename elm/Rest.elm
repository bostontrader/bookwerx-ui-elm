module Rest exposing
    ( createAccountCommand
    , deleteAccountCommand
    , fetchAccountsCommand
    , fetchAccountCommand
    , createCurrencyCommand
    , deleteCurrencyCommand
    , fetchCurrenciesCommand
    , fetchCurrencyCommand
    )

import Http
import RemoteData

import Types exposing
    ( Account
    , Currency
    , CurrencyEditHttpResponse(..)
    , Msg
        ( AccountCreated
        , AccountDeleted
        , AccountsReceived
        , AccountReceived
        , CurrencyCreated
        , CurrencyDeleted
        , CurrenciesReceived
        , CurrencyReceived
        )
    )

import Json.Decode exposing (Decoder, int, list, oneOf, string)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode


-- Accounts
accountDecoder : Decoder Account
accountDecoder =
    decode Account
        |> required "_id" string
        |> required "title" string

fetchAccountsCommand : Cmd Msg
fetchAccountsCommand =
    list accountDecoder
        |> Http.get "http://localhost:3003/accounts"
        |> RemoteData.sendRequest
        |> Cmd.map AccountsReceived

fetchAccountCommand : String -> Cmd Msg
fetchAccountCommand account_id =
    accountDecoder
        |> Http.get ("http://localhost:3003/accounts/" ++ account_id)
        |> RemoteData.sendRequest
        |> Cmd.map AccountReceived

{-updateAccountCommand : Account -> Cmd Msg
updateAccountCommand account =
    updateAccountRequest account
        |> Http.send AccountUpdated

updateAccountRequest : Account -> Http.Request Account
updateAccountRequest account =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:5019/accounts/" ++ (toString account.id)
        , body = Http.jsonBody (accountEncoder account)
        , expect = Http.expectJson accountDecoder
        , timeout = Nothing
        , withCredentials = False
        }

accountEncoder : Account -> Encode.Value
accountEncoder account =
    Encode.object
        [ ( "id", Encode.int account.id )
        , ( "title", Encode.string account.title )
        , ( "author", authorEncoder account.author )
        ]


authorEncoder : Author -> Encode.Value
authorEncoder author =
    Encode.object
        [ ( "name", Encode.string author.name )
        , ( "url", Encode.string author.url )
        ] -}

deleteAccountCommand : Account -> Cmd Msg
deleteAccountCommand account =
    deleteAccountRequest account
        |> Http.send AccountDeleted


deleteAccountRequest : Account -> Http.Request String
deleteAccountRequest account =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:3003/accounts/" ++ account.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

createAccountCommand : Account -> Cmd Msg
createAccountCommand account =
    createAccountRequest account
        |> Http.send AccountCreated

--createAccountRequest : Account -> Http.Request Account
--createAccountRequest account =
    --Http.request
        --{ method = "POST"
        --, headers = []
        --, url = "http://localhost:3003/accounts"
        --, body = Http.jsonBody (newAccountEncoder account)
        --, expect = Http.expectJson accountDecoder
        --, timeout = Nothing
        --, withCredentials = False
        --}

createAccountRequest : Account -> Http.Request Account
createAccountRequest account =
    Http.post
        "http://localhost:3003/accounts"
        (Http.jsonBody (newAccountEncoder account)) accountDecoder

newAccountEncoder : Account -> Encode.Value
newAccountEncoder account =
    Encode.object
        [ ( "title", Encode.string account.title ) ]



-- Currencies
type alias User =
    { name : String
    , email : String
    , age : Int
    }

type alias Error =
    { key : String
    , value : String
    }

type alias CurrencyEditValidResponse =
    { data : Currency
    }

type alias ErrorResponse =
    { errors : List Error
    }


-----

--userResponseDecoder : Json.Decode.Decoder UserValidResponse
--userResponseDecoder =
--    Json.Decode.Pipeline.decode UserValidResponse
--        |> Json.Decode.Pipeline.required "data" userDecoder

currencyEditResponseDecoder : Json.Decode.Decoder CurrencyEditValidResponse
currencyEditResponseDecoder =
    Json.Decode.Pipeline.decode CurrencyEditValidResponse
        |> Json.Decode.Pipeline.required "data" currencyDecoder

-----

errorDecoder : Json.Decode.Decoder Error
errorDecoder =
    Json.Decode.Pipeline.decode Error
        |> Json.Decode.Pipeline.required "key" Json.Decode.string
        |> Json.Decode.Pipeline.required "value" Json.Decode.string

errorListDecoder : Json.Decode.Decoder (List Error)
errorListDecoder =
    Json.Decode.list errorDecoder

errorResponseDecoder : Json.Decode.Decoder ErrorResponse
errorResponseDecoder =
    Json.Decode.Pipeline.decode ErrorResponse
        |> Json.Decode.Pipeline.required "errors" errorListDecoder

validCurrencyEditDecoder : Decoder CurrencyEditHttpResponse
validCurrencyEditDecoder =
    Json.Decode.map
        (\response -> ValidCurrencyEditResponse response.data)
        currencyEditResponseDecoder

errorCurrencyEditDecoder : Json.Decode.Decoder CurrencyEditHttpResponse
errorCurrencyEditDecoder =
    Json.Decode.map
    (\response -> ErrorCurrencyEditResponse response.errors)
    errorResponseDecoder


currencyDecoderA : Decoder CurrencyEditHttpResponse
currencyDecoderA =
    Json.Decode.oneOf
        [ validCurrencyEditDecoder
        , errorCurrencyEditDecoder
        ]

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


fetchCurrencyCommand : String -> Cmd Msg
fetchCurrencyCommand currency_id =
    currencyDecoderA
        |> Http.get ("http://localhost:3003/currencies/" ++ currency_id)
        |> RemoteData.sendRequest
        |> Cmd.map CurrencyReceived


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
