-- API Level C.  See README.md
module Category.API.Post exposing ( postCategoryCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( CategoryMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CategoriesPost ) )

import Category.Plumbing exposing
    ( CategoryPostHttpResponse(..)
    , PostCategoryResponse
    )
import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing (..)


postCategoryCommand : Category -> Cmd Msg
postCategoryCommand category =
    ( Http.request
        { method = "POST"
        , headers = []
        , url = extractUrlProxied CategoriesPost -- this is a route not a Msg
        , body = Http.jsonBody (newCategoryEncoder category)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map CategoryPosted
    |> Cmd.map CategoryMsgA


newCategoryEncoder : Category -> Encode.Value
newCategoryEncoder category =
    Encode.object
        [ ( "title", Encode.string category.title )
        ]


responseDecoder : Decoder CategoryPostHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorCategoryPostDecoder
        ]


dataResponseDecoderA : Decoder CategoryPostHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> CategoryPostDataResponse response.data) -- this picks out the data field
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" postCategoryResponseDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : PostCategoryResponse }

errorCategoryPostDecoder : Decoder CategoryPostHttpResponse -- Same!
errorCategoryPostDecoder =
    map
    (\response -> CategoryPostErrorsResponse response.errors)
    errorsResponseDecoder


postCategoryResponseDecoder : Decoder PostCategoryResponse
postCategoryResponseDecoder =
    decode PostCategoryResponse
        |> required "insertedId" string