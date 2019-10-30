module Apikey.MsgB exposing (MsgB(..))

import Apikey.Plumbing exposing( ApikeyPostHttpResponseString)
import RemoteData exposing (WebData)


type
    MsgB
    -- post
    = PostApikey String
    | ApikeyPosted (WebData ApikeyPostHttpResponseString)
      -- edit
    | UpdateApikey String
