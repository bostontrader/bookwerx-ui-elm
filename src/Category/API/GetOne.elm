module Category.API.GetOne exposing (getOneCategoryCommand)

import Category.MsgB exposing (..)
import Http
import Msg exposing (Msg(..))
import RemoteData


getOneCategoryCommand : String -> Cmd Msg
getOneCategoryCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> CategoryReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CategoryMsgA