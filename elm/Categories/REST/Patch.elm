-- REST Level C.  See README.md
module Categories.REST.Patch exposing ( patchCategoryCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Categories.REST.JSON exposing
    ( patchCategoryDecoder
    , categoryEncoder
    )

import Types exposing
    ( Msg ( CategoryPatched )
    , RouteProxied ( CategoriesPatch )
    , Category
    )

patchCategoryCommand : Category -> Cmd Msg
patchCategoryCommand category =
    Cmd.map CategoryPatched
        ( RemoteData.sendRequest
            ( Http.request
                { method = "PATCH"
                , headers = []
                , url = ( extractUrlProxied CategoriesPatch )  ++ category.id
                , body = Http.jsonBody (categoryEncoder category)
                , expect = Http.expectJson patchCategoryDecoder
                , timeout = Nothing
                , withCredentials = False
                }
            )
        )
