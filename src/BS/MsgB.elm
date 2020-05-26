module BS.MsgB exposing (MsgB(..))

import BS.Model exposing (BSSection, FModel)
import RemoteData exposing (WebData)

type
    MsgB
        = FormChanged FModel

        -- These come from the form fields, in order.  Triggered by the Submit button.
        | GetDistributions String String String String String String

        -- The balance sheet is created by sending five different queries, one for each of the five major categories.
        -- Whenever the response to any of these queries is received, fire this message
        | DistributionsReceived BSSection (WebData String)
