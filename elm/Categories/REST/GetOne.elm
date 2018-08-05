-- REST Level C.  See README.md
module Categories.REST.GetOne exposing ( getOneCategoryCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Categories.REST.JSON exposing
    ( getOneCategoryDecoder
    , categoryEncoder
    )

import Types exposing
    ( Msg ( CategoryReceived )
    , RouteProxied ( CategoriesGetOne )
    , Category
    )

--getOneCategoryCommand : String -> Cmd Msg
--getOneCategoryCommand category_id =
--    categoryDecoderA
--        |> Http.get ("http://localhost:3004/categories/" ++ category_id)
--        |> RemoteData.sendRequest
--        |> Cmd.map CategoryReceived

getOneCategoryCommand : String -> Cmd Msg
getOneCategoryCommand category_id =
    Cmd.map CategoryReceived
        ( RemoteData.sendRequest
            ( Http.get ( ( extractUrlProxied CategoriesGetOne ) ++ category_id )  getOneCategoryDecoder )
        )
