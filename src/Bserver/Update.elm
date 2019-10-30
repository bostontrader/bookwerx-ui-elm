module Bserver.Update exposing (bserverUpdate)

import Bserver.Ping exposing (pingBserverCommand)
import Bserver.MsgB exposing( MsgB (..) )
import Bserver.Model
import Msg exposing (Msg)
import RemoteData
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


bserverUpdate : MsgB -> Language -> Bserver.Model.Model -> { bservers : Bserver.Model.Model, cmd : Cmd Msg, log : List String }
bserverUpdate bserverMsgB language model  =
    case bserverMsgB of
        -- ping
        PingBserver bserverURL ->
            { bservers =
                { model | wdBserver = RemoteData.Loading }
            , cmd = pingBserverCommand bserverURL
            , log = [ "GET " ++ model.baseURL ]
            }

        PingReceived response ->
            { bservers =
                { model | wdBserver = response }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage response language ]
            }

        UpdateBserverURL newURL ->
            { bservers = { model | baseURL = newURL }, cmd = Cmd.none, log = [] }
