-- REST Level A.  See README.md
module Categories.REST.Delete exposing ( deleteCategoryCommand )

import Http

import Routing exposing ( extractUrlProxied )
import Types exposing
    ( Msg ( CategoryDeleted )
    , RouteProxied ( CategoriesDelete )
    , Category
    )


deleteCategoryCommand : Category -> Cmd Msg
deleteCategoryCommand category =
    deleteCategoryRequest category
        |> Http.send CategoryDeleted


deleteCategoryRequest : Category -> Http.Request String
deleteCategoryRequest category =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = ( extractUrlProxied CategoriesDelete ) ++ category.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
