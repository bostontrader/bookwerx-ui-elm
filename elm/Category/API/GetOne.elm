-- API Level C.  See README.md
module Category.API.GetOne exposing ( getOneCategoryCommand )

import Http
import Json.Decode exposing ( Decoder, map )
import Json.Decode.Pipeline exposing ( decode, required )
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( CategoryMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CategoriesGetOne ) )

import Category.API.JSON exposing ( categoryDecoder )
import Category.Plumbing exposing ( CategoryGetOneHttpResponse(..) )
import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing (..)


getOneCategoryCommand : String -> Cmd Msg
getOneCategoryCommand category_id =
    responseDecoder
    |> Http.get ( ( extractUrlProxied CategoriesGetOne ) ++ category_id )
    |> RemoteData.sendRequest
    |> Cmd.map CategoryReceived
    |> Cmd.map CategoryMsgA


responseDecoder : Decoder CategoryGetOneHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorCategoryGetOneDecoder
        ]


dataResponseDecoderA : Decoder CategoryGetOneHttpResponse -- Same!
dataResponseDecoderA =
    map
        (\response -> CategoryGetOneDataResponse response.data) -- this picks out the data field
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" categoryDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : Category }


errorCategoryGetOneDecoder : Decoder CategoryGetOneHttpResponse -- Same!
errorCategoryGetOneDecoder =
    map
    (\response -> CategoryGetOneErrorsResponse response.errors)
    errorsResponseDecoder
