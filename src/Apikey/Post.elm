module Apikey.Post exposing (postApikeyCommand)

import Apikey.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


postApikeyCommand : String -> Cmd Msg
postApikeyCommand apikey_url =
    Http.post
        { url = apikey_url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> ApikeyPosted)
        }
        |> Cmd.map ApikeyMsgA