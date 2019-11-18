module Category.API.JSON exposing
    ( categoriesDecoder
    , categoryDecoder
    , categoryShortDecoder
    )

import Category.Category exposing (Category, CategoryShort)
import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)


categoriesDecoder : Decoder (List Category)
categoriesDecoder =
    Json.Decode.list categoryDecoder


categoryDecoder : Decoder Category
categoryDecoder =
    Json.Decode.succeed Category
        |> required "id" int
        |> required "apikey" string
        |> required "symbol" string
        |> required "title" string


categoryShortDecoder : Decoder CategoryShort
categoryShortDecoder =
    Json.Decode.succeed CategoryShort
        |> required "category_symbol" string
