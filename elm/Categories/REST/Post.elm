-- REST Level C.  See README.md
module Categories.REST.Post exposing ( postCategoryCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Categories.REST.JSON exposing
    ( newCategoryEncoder
    , postCategoryDecoder
    )

import Types exposing
    ( Msg ( CategoryCreated )
    , RouteProxied ( CategoriesPost )
    , Category
    )

postCategoryCommand : Category -> Cmd Msg
postCategoryCommand category =
    Cmd.map CategoryCreated
        ( RemoteData.sendRequest
            ( Http.request
                { method = "POST"
                , headers = []
                , url = extractUrlProxied CategoriesPost
                , body = Http.jsonBody (newCategoryEncoder category)
                , expect = Http.expectJson postCategoryDecoder
                , timeout = Nothing
                , withCredentials = False
                }
            )
        )
