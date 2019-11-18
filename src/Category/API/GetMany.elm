module Category.API.GetMany exposing (getManyCategoriesCommand)

import Category.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


getManyCategoriesCommand : String -> Cmd Msg
getManyCategoriesCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> CategoriesReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CategoryMsgA
