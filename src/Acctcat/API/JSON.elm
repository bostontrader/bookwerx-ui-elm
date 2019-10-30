module Acctcat.API.JSON exposing
    ( acctcatDecoder
    , acctcatsDecoder
    )

import Acctcat.Acctcat exposing (Acctcat)
import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)


acctcatsDecoder : Decoder (List Acctcat)
acctcatsDecoder =
    Json.Decode.list acctcatDecoder


acctcatDecoder : Decoder Acctcat
acctcatDecoder =
    Json.Decode.succeed Acctcat
        |> required "id" int
        |> required "apikey" string
        |> required "account_id" int
        |> required "category_id" int
