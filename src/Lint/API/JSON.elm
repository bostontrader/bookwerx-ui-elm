module Lint.API.JSON exposing (lintsDecoder)

import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)
import Lint.Lint exposing (Lint)


lintsDecoder : Decoder (List Lint)
lintsDecoder =
    Json.Decode.list lintDecoder


lintDecoder : Decoder Lint
lintDecoder =
    Json.Decode.succeed Lint
        |> required "id" int
        |> required "symbol" string
        |> required "title" string
