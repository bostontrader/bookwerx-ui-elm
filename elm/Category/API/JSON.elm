module Category.API.JSON exposing
    ( categoryDecoder
    , categoryEncoder
    )

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Category.Category exposing ( Category )


categoryEncoder : Category -> Encode.Value
categoryEncoder category =
    Encode.object
        [ ("title", Encode.string category.title)
        ]


categoryDecoder : Decoder Category
categoryDecoder =
    decode Category
        |> required "_id" string
        |> required "title" string
