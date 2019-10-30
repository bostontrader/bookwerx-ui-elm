module Category.API.Post exposing (postCategoryCommand)

import Category.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


postCategoryCommand : String -> String -> String -> Cmd Msg
postCategoryCommand url contentType post_body =
    Http.request
        { method = "POST"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> CategoryPosted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CategoryMsgA
