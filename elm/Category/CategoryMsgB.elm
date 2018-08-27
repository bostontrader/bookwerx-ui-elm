module Category.CategoryMsgB exposing ( CategoryMsgB (..) )

import Http
import RemoteData exposing ( WebData )

import Category.Plumbing exposing
    ( CategoryId
    , CategoryGetOneHttpResponse
    , CategoryPatchHttpResponse
    , CategoryPostHttpResponse
    )

import Category.Category exposing ( Category )

type CategoryMsgB
    -- delete
    = DeleteCategory CategoryId
    | CategoryDeleted (Result Http.Error String)

    -- getMany
    | CategoriesReceived (WebData (List Category))

    -- getOne
    | CategoryReceived (WebData CategoryGetOneHttpResponse)

    -- patch
    | PatchCategory
    | CategoryPatched (WebData CategoryPatchHttpResponse)

    -- post
    | PostCategory
    | CategoryPosted (WebData CategoryPostHttpResponse)

    -- edit
    | UpdateCategoryTitle String
