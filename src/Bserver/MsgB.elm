module Bserver.MsgB exposing (MsgB(..))

import Bserver.Plumbing
    exposing
        ( BserverPingResponse
        , BserverURL
        )
import RemoteData exposing (WebData)


type
    MsgB
    -- ping connection
    = PingBserver BserverURL
    | PingReceived (WebData BserverPingResponse)
      -- edit
    | UpdateBserverURL String
