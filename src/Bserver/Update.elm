module Bserver.Update exposing (bserverUpdate)

import Bserver.Model
import Bserver.MsgB exposing (MsgB(..))
import Bserver.Ping exposing (pingBserverCommand)
import Msg exposing (Msg)
import RemoteData
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


bserverUpdate : MsgB -> Language -> Bserver.Model.Model -> { bservers : Bserver.Model.Model, cmd : Cmd Msg }
bserverUpdate bserverMsgB language model =
    case bserverMsgB of
        -- ping
        PingBserver bserverURL ->
            { bservers =
                { model | wdBserver = RemoteData.Loading }
            , cmd = pingBserverCommand bserverURL
            }

        PingReceived response ->
            { bservers =
                { model | wdBserver = response }
            , cmd = Cmd.none
            }

        UpdateBserverURL newURL ->
            { bservers = { model | baseURL = newURL }, cmd = Cmd.none }
