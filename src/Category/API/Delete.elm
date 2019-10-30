module Category.API.Delete exposing (deleteCategoryCommand)

import Category.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


deleteCategoryCommand : String -> Cmd Msg
deleteCategoryCommand url =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> CategoryDeleted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CategoryMsgA