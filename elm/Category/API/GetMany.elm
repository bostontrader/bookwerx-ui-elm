-- API Level B.  See README.md
module Category.API.GetMany exposing ( getManyCategoriesCommand )

import Http
import Json.Decode exposing ( list )
import RemoteData

import Msg exposing ( Msg ( CategoryMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CategoriesGetMany ) )

import Category.API.JSON exposing ( categoryDecoder )
import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing ( CategoryMsgB ( CategoriesReceived ) )


getManyCategoriesCommand : Cmd Msg
getManyCategoriesCommand =
    list categoryDecoder
        |> Http.get ( extractUrlProxied CategoriesGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map CategoriesReceived
        |> Cmd.map CategoryMsgA
