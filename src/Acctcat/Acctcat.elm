module Acctcat.Acctcat exposing (Acctcat, AcctcatJoined)


type alias Acctcat =
    { id : Int
    , apikey : String
    , account_id : Int
    , category_id : Int
    }


type alias AcctcatJoined =
    { id : Int
    , apikey : String
    , account_title : String
    , category_id : Int
    , currency_symbol : String
    }
