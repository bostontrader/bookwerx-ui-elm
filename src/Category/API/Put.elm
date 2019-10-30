module Category.API.Put exposing (putCategoryCommand)

import Category.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


putCategoryCommand : String -> String -> String -> Cmd Msg
putCategoryCommand url contentType put_body =
    Http.request
        { method = "PUT"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType put_body
        , expect = Http.expectString (RemoteData.fromResult >> CategoryPutted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CategoryMsgA
