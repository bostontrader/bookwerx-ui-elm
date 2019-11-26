module Report.Report exposing (AccountSummary)

import DecimalFP exposing (DFP)



-- One line of the report


type alias AccountSummary =
    { account_id : Int
    , damt : DFP
    }
