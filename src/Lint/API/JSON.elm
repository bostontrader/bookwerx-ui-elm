module Lint.API.JSON exposing (lintsDecoder)

import Lint.Lint exposing (Lint)
import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)


lintsDecoder : Decoder (List Lint)
lintsDecoder =
    Json.Decode.list lintDecoder


lintDecoder : Decoder Lint
lintDecoder =
    Json.Decode.succeed Lint
        |> required "id" int
        |> required "symbol" string
        |> required "title" string
