module Categories.Rest exposing
    ( createCategoryCommand
    , deleteCategoryCommand
    , fetchCategoryCommand
    , fetchCategoriesCommand
    , updateCategoryCommand
    )

import Http
import RemoteData

import Types exposing
    ( Msg
        ( CategoryCreated
        , CategoryDeleted
        , CategoriesReceived
        , CategoryReceived
        , CategoryUpdated
        )
    , Category
    , CategoryEditHttpResponse(..)
    )

import Json.Decode exposing (Decoder, int, list, oneOf, string)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode

type alias CategoryEditValidResponse = { data : Category }

type alias Error =
    { key : String, value : String }

type alias ErrorResponse =
    { errors : List Error }

errorDecoder : Json.Decode.Decoder Error
errorDecoder =
    Json.Decode.Pipeline.decode Error
        |> Json.Decode.Pipeline.required "key" Json.Decode.string
        |> Json.Decode.Pipeline.required "value" Json.Decode.string

errorListDecoder : Json.Decode.Decoder (List Error)
errorListDecoder =
    Json.Decode.list errorDecoder

errorResponseDecoder : Json.Decode.Decoder ErrorResponse
errorResponseDecoder =
    Json.Decode.Pipeline.decode ErrorResponse
        |> Json.Decode.Pipeline.required "errors" errorListDecoder


categoryEditResponseDecoder : Json.Decode.Decoder CategoryEditValidResponse
categoryEditResponseDecoder =
    Json.Decode.Pipeline.decode CategoryEditValidResponse
        |> Json.Decode.Pipeline.required "data" categoryDecoder

validCategoryEditDecoder : Decoder CategoryEditHttpResponse
validCategoryEditDecoder =
    Json.Decode.map
        (\response -> ValidCategoryEditResponse response.data)
        categoryEditResponseDecoder

errorCategoryEditDecoder : Json.Decode.Decoder CategoryEditHttpResponse
errorCategoryEditDecoder =
    Json.Decode.map
    (\response -> ErrorCategoryEditResponse response.errors)
    errorResponseDecoder


categoryDecoderA : Decoder CategoryEditHttpResponse
categoryDecoderA =
    Json.Decode.oneOf
        [ validCategoryEditDecoder
        , errorCategoryEditDecoder
        ]

categoryDecoder : Decoder Category
categoryDecoder =
    decode Category
        |> required "_id" string
        |> required "title" string

fetchCategoriesCommand : Cmd Msg
fetchCategoriesCommand =
    list categoryDecoder
        |> Http.get "http://localhost:3003/categories"
        |> RemoteData.sendRequest
        |> Cmd.map CategoriesReceived

fetchCategoryCommand : String -> Cmd Msg
fetchCategoryCommand category_id =
    categoryDecoderA
        |> Http.get ("http://localhost:3003/categories/" ++ category_id)
        |> RemoteData.sendRequest
        |> Cmd.map CategoryReceived

updateCategoryCommand : Category -> Cmd Msg
updateCategoryCommand category =
    updateCategoryRequest category
        |> Http.send CategoryUpdated

updateCategoryRequest : Category -> Http.Request Category
updateCategoryRequest category =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:3003/categories/" ++ category.id
        , body = Http.jsonBody (categoryEncoder category)
        , expect = Http.expectJson categoryDecoder
        , timeout = Nothing
        , withCredentials = False
        }

categoryEncoder : Category -> Encode.Value
categoryEncoder category =
    Encode.object
        [ ("id", Encode.string category.id)
        , ("title", Encode.string category.title)
        ]

deleteCategoryCommand : Category -> Cmd Msg
deleteCategoryCommand category =
    deleteCategoryRequest category
        |> Http.send CategoryDeleted

deleteCategoryRequest : Category -> Http.Request String
deleteCategoryRequest category =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:3003/categories/" ++ category.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

createCategoryCommand : Category -> Cmd Msg
createCategoryCommand category =
    createCategoryRequest category
        |> Http.send CategoryCreated

createCategoryRequest : Category -> Http.Request Category
createCategoryRequest category =
    Http.post
        "http://localhost:3003/categories"
        (Http.jsonBody (newCategoryEncoder category)) categoryDecoder

newCategoryEncoder : Category -> Encode.Value
newCategoryEncoder category =
    Encode.object
        [ ( "title", Encode.string category.title )
        ]
