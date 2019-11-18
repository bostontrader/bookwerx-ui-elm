module Bserver.Ping exposing (pingBserverCommand)

import Bserver.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData



-- given a url for the bserver


pingBserverCommand : String -> Cmd Msg
pingBserverCommand url =
    Http.get
        { url = url
        , expect = Http.expectString (RemoteData.fromResult >> PingReceived)
        }
        |> Cmd.map BserverMsgA
