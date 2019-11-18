module Lint.MsgB exposing (MsgB(..))

import RemoteData exposing (WebData)


type MsgB
    = GetLintCategories String
    | GetLintCurrencies String
    | LintsReceived (WebData String) -- this works because GetLintxxx returns the same format
