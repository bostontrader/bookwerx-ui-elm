-- API Level C.  See README.md
module Category.API.Patch exposing ( patchCategoryCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( CategoryMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CategoriesPatch ) )

import Category.API.JSON exposing ( categoryDecoder, categoryEncoder )
import Category.Plumbing exposing ( CategoryPatchHttpResponse (..) )
import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing ( CategoryMsgB ( CategoryPatched ) )


patchCategoryCommand : Category -> Cmd Msg
patchCategoryCommand category =
    ( Http.request
        { method = "PATCH"
        , headers = []
        , url = ( extractUrlProxied CategoriesPatch )  ++ category.id
        , body = Http.jsonBody (categoryEncoder category)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map CategoryPatched
    |> Cmd.map CategoryMsgA


responseDecoder : Decoder CategoryPatchHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorCategoryPatchDecoder
        ]


dataResponseDecoderA : Decoder CategoryPatchHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> CategoryPatchDataResponse response.data)
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" categoryDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : Category }


errorCategoryPatchDecoder : Decoder CategoryPatchHttpResponse -- Same!
errorCategoryPatchDecoder =
    Json.Decode.map
    (\response -> CategoryPatchErrorsResponse response.errors)
    errorsResponseDecoder
