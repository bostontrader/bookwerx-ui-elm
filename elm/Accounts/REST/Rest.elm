--module Accounts.Rest exposing
--    ( createAccountCommand
--    , deleteAccountCommand
--    , fetchAccountCommand
--    , fetchAccountsCommand
--    , updateAccountCommand
--    )

--import Http
--import RemoteData

--import Types exposing
--    ( Msg
--        ( AccountCreated
--        , AccountDeleted
--        , AccountsReceived
--        , AccountReceived
--        , AccountUpdated
--        )
--    , Account
--    , AccountEditHttpResponse(..)
--    )

--import Json.Decode exposing (Decoder, int, list, oneOf, string)
--import Json.Decode.Pipeline exposing (decode, required)
--import Json.Encode as Encode

--type alias AccountEditValidResponse = { data : Account }

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


--accountEditResponseDecoder : Json.Decode.Decoder AccountEditValidResponse
--accountEditResponseDecoder =
--    Json.Decode.Pipeline.decode AccountEditValidResponse
--        |> Json.Decode.Pipeline.required "data" accountDecoder

--validAccountEditDecoder : Decoder AccountEditHttpResponse
--validAccountEditDecoder =
--    Json.Decode.map
--        (\response -> ValidAccountEditResponse response.data)
--        accountEditResponseDecoder

--errorAccountEditDecoder : Json.Decode.Decoder AccountEditHttpResponse
--errorAccountEditDecoder =
--    Json.Decode.map
--    (\response -> ErrorAccountEditResponse response.errors)
--    errorResponseDecoder


--accountDecoderA : Decoder AccountEditHttpResponse
--accountDecoderA =
--    Json.Decode.oneOf
--        [ validAccountEditDecoder
--        , errorAccountEditDecoder
--        ]

--accountDecoder : Decoder Account
--accountDecoder =
--    decode Account
--        |> required "_id" string
--        |> required "title" string

--fetchAccountsCommand : Cmd Msg
--fetchAccountsCommand =
--    list accountDecoder
--        |> Http.get "http://localhost:3003/accounts"
--        |> RemoteData.sendRequest
--        |> Cmd.map AccountsReceived

--fetchAccountCommand : String -> Cmd Msg
--fetchAccountCommand account_id =
--    accountDecoderA
--        |> Http.get ("http://localhost:3003/accounts/" ++ account_id)
--        |> RemoteData.sendRequest
--        |> Cmd.map AccountReceived

--updateAccountCommand : Account -> Cmd Msg
--updateAccountCommand account =
--    updateAccountRequest account
--        |> Http.send AccountUpdated

--updateAccountRequest : Account -> Http.Request Account
--updateAccountRequest account =
--    Http.request
--        { method = "PATCH"
--        , headers = []
--        , url = "http://localhost:3003/accounts/" ++ account.id
--        , body = Http.jsonBody (accountEncoder account)
--        , expect = Http.expectJson accountDecoder
--        , timeout = Nothing
--        , withCredentials = False
--        }

--accountEncoder : Account -> Encode.Value
--accountEncoder account =
--    Encode.object
--        [ ("id", Encode.string account.id)
--        , ("title", Encode.string account.title)
--        ]

--deleteAccountCommand : Account -> Cmd Msg
--deleteAccountCommand account =
--    deleteAccountRequest account
--        |> Http.send AccountDeleted

--deleteAccountRequest : Account -> Http.Request String
--deleteAccountRequest account =
--    Http.request
--        { method = "DELETE"
--        , headers = []
--        , url = "http://localhost:3003/accounts/" ++ account.id
--        , body = Http.emptyBody
--        , expect = Http.expectString
--        , timeout = Nothing
--        , withCredentials = False
--        }

--createAccountCommand : Account -> Cmd Msg
--createAccountCommand account =
--    createAccountRequest account
--        |> Http.send AccountCreated

--createAccountRequest : Account -> Http.Request Account
--createAccountRequest account =
--    Http.post
--        "http://localhost:3003/accounts"
--        (Http.jsonBody (newAccountEncoder account)) accountDecoder

--newAccountEncoder : Account -> Encode.Value
--newAccountEncoder account =
--    Encode.object
--        [ ( "title", Encode.string account.title )
--        ]
