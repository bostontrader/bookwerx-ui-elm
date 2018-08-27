module Account.API.JSON exposing
    ( accountDecoder
    , accountEncoder
    )

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Account.Account exposing ( Account )


accountEncoder : Account -> Encode.Value
accountEncoder account =
    Encode.object
        [ ("title", Encode.string account.title)
        ]


accountDecoder : Decoder Account
accountDecoder =
    decode Account
        |> required "_id" string
        |> required "title" string
