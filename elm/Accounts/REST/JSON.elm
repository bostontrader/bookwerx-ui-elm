module Accounts.REST.JSON exposing
    ( getOneAccountDecoder
    , patchAccountDecoder
    , postAccountDecoder
    , accountDecoder
    , accountEncoder, newAccountEncoder
    , accountPatchResponseDecoder
    )

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Types exposing
    ( errorResponseDecoder
    , Account
    , AccountPostHttpResponse(..)
    , AccountPatchHttpResponse(..)
    )

accountEncoder : Account -> Encode.Value
accountEncoder account =
    Encode.object
        [ ("id", Encode.string account.id)
        , ("title", Encode.string account.title)
        ]

newAccountEncoder : Account -> Encode.Value
newAccountEncoder account =
    Encode.object
        [ ( "title", Encode.string account.title )
        ]

accountDecoder : Decoder Account
accountDecoder =
    decode Account
        |> required "_id" string
        |> required "title" string

-- getOne
getOneAccountDecoder : Decoder AccountPostHttpResponse
getOneAccountDecoder =
    Json.Decode.oneOf
        [ validAccountEditDecoder
        , errorAccountEditDecoder
        ]

validAccountEditDecoder : Decoder AccountPostHttpResponse
validAccountEditDecoder =
    Json.Decode.map
        (\response -> ValidAccountPostResponse response.data)
        accountEditResponseDecoder

errorAccountEditDecoder : Json.Decode.Decoder AccountPostHttpResponse
errorAccountEditDecoder =
    Json.Decode.map
    (\response -> ErrorAccountPostResponse response.errors)
    errorResponseDecoder

accountEditResponseDecoder : Json.Decode.Decoder AccountEditValidResponse
accountEditResponseDecoder =
    Json.Decode.Pipeline.decode AccountEditValidResponse
        |> Json.Decode.Pipeline.required "data" accountDecoder

type alias AccountEditValidResponse = { data : Account }

-- patch
patchAccountDecoder : Decoder AccountPatchHttpResponse
patchAccountDecoder =
    Json.Decode.oneOf
        [ validAccountPatchDecoder
        , errorAccountPatchDecoder
        ]

validAccountPatchDecoder : Decoder AccountPatchHttpResponse
validAccountPatchDecoder =
    Json.Decode.map
        (\response -> ValidAccountPatchResponse response.data)
        accountPatchResponseDecoder

accountPatchResponseDecoder : Json.Decode.Decoder AccountPatchValidResponse
accountPatchResponseDecoder =
    Json.Decode.Pipeline.decode AccountPatchValidResponse
        |> Json.Decode.Pipeline.required "data" accountDecoder

errorAccountPatchDecoder : Json.Decode.Decoder AccountPatchHttpResponse
errorAccountPatchDecoder =
    Json.Decode.map
    (\response -> ErrorAccountPatchResponse response.errors)
    errorResponseDecoder

type alias AccountPatchValidResponse = { data : Account }


-- post
--postAccountDecoder
--resultDecoder : Decoder PostAccountResult
--resultDecoder =
--    decode PostAccountResult
--        |> required "n" int
--        |> required "ok" int
postAccountDecoder : Decoder AccountPostHttpResponse
postAccountDecoder =
    Json.Decode.oneOf
        [ validAccountPostDecoder
        , errorAccountPostDecoder
        ]

validAccountPostDecoder : Decoder AccountPostHttpResponse
validAccountPostDecoder =
    Json.Decode.map
        (\response -> ValidAccountPostResponse response.data)
        accountPostResponseDecoder

accountPostResponseDecoder : Json.Decode.Decoder AccountPostValidResponse
accountPostResponseDecoder =
    Json.Decode.Pipeline.decode AccountPostValidResponse
        |> Json.Decode.Pipeline.required "data" accountDecoder

errorAccountPostDecoder : Json.Decode.Decoder AccountPostHttpResponse
errorAccountPostDecoder =
    Json.Decode.map
    (\response -> ErrorAccountPostResponse response.errors)
    errorResponseDecoder

type alias AccountPostValidResponse = { data : Account }
