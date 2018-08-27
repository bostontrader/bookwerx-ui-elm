-- These are separated from Types because otherwise there is an issue with circular dependencies
module TypesB exposing
    ( BWCore_Error
    , Flags
    , FlashMsg
    , FlashSeverity (..)
    )

import Time exposing (Time)

type alias Flags =
  { bwcoreHost : String
  , bwcorePort : Int
  }


type alias BWCore_Error =
    { key : String, value : String}


type FlashSeverity
    = FlashSuccess
    | FlashWarning
    | FlashError


type alias FlashMsg =
    { message : String
    , severity : FlashSeverity
    , id : Int
    , expirationTime : Time
    }