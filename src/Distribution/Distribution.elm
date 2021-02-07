module Distribution.Distribution exposing
    ( DistributionEB
    , DistributionJoined
    , DistributionRaw
    , DistributionReport
    )

import IntField exposing (IntField)
import Types exposing (DRCR)



-- As decoded from JSON from the server


type alias DistributionRaw =
    { id : Int
    , apikey : String
    , account_id : Int
    , amount : Int
    , amount_exp : Int
    , transaction_id : Int
    }



-- Augmented to serve as our editBuffer


type alias DistributionEB =
    { id : Int
    , apikey : String
    , account_id : Int
    , currency_filter_id : Int
    , amount : IntField
    , amount_exp : IntField
    , transaction_id : Int
    , drcr : DRCR
    }



-- A distribution joined with other useful and related info.  When listing distributions for an account, these extra fields are a convenience for the UI.


type alias DistributionJoined =
    { account_title : String
    , aid : Int
    , amount : Int
    , amount_exp : Int
    , apikey : String
    , id : Int
    , tid : Int
    , tx_notes : String
    , tx_time : String
    }


type alias DistributionReport =
    { account_id : Int
    , amount : Int
    , amount_exp : Int
    , time : String
    }
