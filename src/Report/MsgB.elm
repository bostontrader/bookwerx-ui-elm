module Report.MsgB exposing (MsgB(..))

import RemoteData exposing (WebData)


type
    MsgB
    -- getMany
    = GetDistributions String
    | DistributionsReceived (WebData String)
      -- edit
    | ToggleOmitZeros
    | UpdateCategoryID String
    | UpdateDecimalPlaces Int
    | UpdateSOF String
    | UpdateStartTime String
    | UpdateStopTime String
