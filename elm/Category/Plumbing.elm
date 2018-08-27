module Category.Plumbing exposing
    ( CategoryId
    , CategoryGetOneHttpResponse(..)
    , CategoryPatchHttpResponse(..)
    , CategoryPostHttpResponse(..)
    , PostCategoryResponse
    )

import RemoteData exposing ( WebData )

import TypesB exposing ( BWCore_Error, FlashMsg )

import Category.Category exposing ( Category )


type alias CategoryId = String

type CategoryGetOneHttpResponse
    = CategoryGetOneDataResponse Category
    | CategoryGetOneErrorsResponse (List BWCore_Error)

type CategoryPatchHttpResponse
    = CategoryPatchDataResponse Category
    | CategoryPatchErrorsResponse (List BWCore_Error)

type CategoryPostHttpResponse
    = CategoryPostDataResponse PostCategoryResponse
    | CategoryPostErrorsResponse (List BWCore_Error)

type alias PostCategoryResponse = { insertedId : String }
