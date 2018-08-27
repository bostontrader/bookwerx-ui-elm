module JSON exposing ( errorsResponseDecoder )

import Json.Decode exposing ( Decoder, list, string )
import Json.Decode.Pipeline exposing ( decode, required )

type alias Error =
    { key : String, value : String }

type alias ErrorResponse =
    { errors : List Error }


errorDecoder : Decoder Error
errorDecoder =
    decode Error
        |> required "key" string
        |> required "value" string


errorListDecoder : Decoder (List Error)
errorListDecoder =
    list errorDecoder


errorsResponseDecoder : Decoder ErrorResponse
errorsResponseDecoder =
    decode ErrorResponse
        |> required "errors" errorListDecoder