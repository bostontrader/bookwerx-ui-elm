module Categories.REST.JSON exposing
    ( getOneCategoryDecoder
    , patchCategoryDecoder
    , postCategoryDecoder
    , categoryDecoder
    , categoryEncoder, newCategoryEncoder
    , categoryPatchResponseDecoder
    )

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Types exposing
    ( errorResponseDecoder
    , Category
    , CategoryPostHttpResponse(..)
    , CategoryPatchHttpResponse(..)
    )

categoryEncoder : Category -> Encode.Value
categoryEncoder category =
    Encode.object
        [ ("id", Encode.string category.id)
        , ("title", Encode.string category.title)
        ]

newCategoryEncoder : Category -> Encode.Value
newCategoryEncoder category =
    Encode.object
        [ ( "title", Encode.string category.title )
        ]

categoryDecoder : Decoder Category
categoryDecoder =
    decode Category
        |> required "_id" string
        |> required "title" string

-- getOne
getOneCategoryDecoder : Decoder CategoryPostHttpResponse
getOneCategoryDecoder =
    Json.Decode.oneOf
        [ validCategoryEditDecoder
        , errorCategoryEditDecoder
        ]

validCategoryEditDecoder : Decoder CategoryPostHttpResponse
validCategoryEditDecoder =
    Json.Decode.map
        (\response -> ValidCategoryPostResponse response.data)
        categoryEditResponseDecoder

errorCategoryEditDecoder : Json.Decode.Decoder CategoryPostHttpResponse
errorCategoryEditDecoder =
    Json.Decode.map
    (\response -> ErrorCategoryPostResponse response.errors)
    errorResponseDecoder

categoryEditResponseDecoder : Json.Decode.Decoder CategoryEditValidResponse
categoryEditResponseDecoder =
    Json.Decode.Pipeline.decode CategoryEditValidResponse
        |> Json.Decode.Pipeline.required "data" categoryDecoder

type alias CategoryEditValidResponse = { data : Category }

-- patch
patchCategoryDecoder : Decoder CategoryPatchHttpResponse
patchCategoryDecoder =
    Json.Decode.oneOf
        [ validCategoryPatchDecoder
        , errorCategoryPatchDecoder
        ]

validCategoryPatchDecoder : Decoder CategoryPatchHttpResponse
validCategoryPatchDecoder =
    Json.Decode.map
        (\response -> ValidCategoryPatchResponse response.data)
        categoryPatchResponseDecoder

categoryPatchResponseDecoder : Json.Decode.Decoder CategoryPatchValidResponse
categoryPatchResponseDecoder =
    Json.Decode.Pipeline.decode CategoryPatchValidResponse
        |> Json.Decode.Pipeline.required "data" categoryDecoder

errorCategoryPatchDecoder : Json.Decode.Decoder CategoryPatchHttpResponse
errorCategoryPatchDecoder =
    Json.Decode.map
    (\response -> ErrorCategoryPatchResponse response.errors)
    errorResponseDecoder

type alias CategoryPatchValidResponse = { data : Category }


-- post
--postCategoryDecoder
--resultDecoder : Decoder PostCategoryResult
--resultDecoder =
--    decode PostCategoryResult
--        |> required "n" int
--        |> required "ok" int
postCategoryDecoder : Decoder CategoryPostHttpResponse
postCategoryDecoder =
    Json.Decode.oneOf
        [ validCategoryPostDecoder
        , errorCategoryPostDecoder
        ]

validCategoryPostDecoder : Decoder CategoryPostHttpResponse
validCategoryPostDecoder =
    Json.Decode.map
        (\response -> ValidCategoryPostResponse response.data)
        categoryPostResponseDecoder

categoryPostResponseDecoder : Json.Decode.Decoder CategoryPostValidResponse
categoryPostResponseDecoder =
    Json.Decode.Pipeline.decode CategoryPostValidResponse
        |> Json.Decode.Pipeline.required "data" categoryDecoder

errorCategoryPostDecoder : Json.Decode.Decoder CategoryPostHttpResponse
errorCategoryPostDecoder =
    Json.Decode.map
    (\response -> ErrorCategoryPostResponse response.errors)
    errorResponseDecoder

type alias CategoryPostValidResponse = { data : Category }
