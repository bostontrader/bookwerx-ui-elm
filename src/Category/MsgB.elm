module Category.MsgB exposing (MsgB(..))

import Category.Plumbing
    exposing
        ( CategoryPostHttpResponseString
        , CategoryPutHttpResponseString
        )
import RemoteData exposing (WebData)


type
    MsgB
    -- delete
    = DeleteCategory String -- url
    | CategoryDeleted (WebData String)
      -- getMany
    | GetManyCategories String
    | CategoriesReceived (WebData String)
      -- getOne
    | GetOneCategory String
    | CategoryReceived (WebData String)
      -- put
    | PutCategory String String String -- url content-type body
    | CategoryPutted (WebData CategoryPutHttpResponseString)
      -- post
    | PostCategory String String String -- url content-type body
    | CategoryPosted (WebData CategoryPostHttpResponseString)
      -- edit
    | UpdateCategoryAccount String
    | UpdateSymbol String
    | UpdateTitle String
