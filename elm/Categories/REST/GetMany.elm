-- REST Level B.  See README.md
module Categories.REST.GetMany exposing ( getManyCategoriesCommand )

import Http
import RemoteData
import Json.Decode exposing ( list )

import Routing exposing ( extractUrlProxied )
import Categories.REST.JSON exposing ( categoryDecoder )
import Types exposing
    ( Msg ( CategoriesReceived )
    , RouteProxied ( CategoriesGetMany )
    , Category
    )

getManyCategoriesCommand : Cmd Msg
getManyCategoriesCommand =
    list categoryDecoder
        |> Http.get ( extractUrlProxied CategoriesGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map CategoriesReceived
