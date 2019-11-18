module Acctcat.Model exposing (Model)

import Acctcat.Acctcat exposing (Acctcat)
import IntField exposing (IntField(..))
import RemoteData exposing (WebData)


type alias Model =
    -- wdAcctcats is the 4 state RemoteData response from GetMany.  If the response is "success" the response is a raw string that shall be decoded as a List of Acctcat and stored in acctcats, -or- if it cannot be decoded it shall be assumed to be an error reported from the server.
    { acctcats : List Acctcat -- JSON decoded from wdAcctcats
    , wdAcctcats : WebData String -- the raw string response from GetMany

    --, wdAcctcat : WebData String
    , editBuffer : Acctcat
    , category_id : Int
    }
