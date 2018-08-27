-- API Level A.  See README.md
module Category.API.Delete exposing ( deleteCategoryCommand )

import Http

import Msg exposing ( Msg ( CategoryMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CategoriesDelete ) )

import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing ( CategoryMsgB ( CategoryDeleted ) )


deleteCategoryCommand : Category -> Cmd Msg
deleteCategoryCommand category =
    deleteCategoryRequest category
        |> Http.send CategoryDeleted
        |> Cmd.map CategoryMsgA


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
