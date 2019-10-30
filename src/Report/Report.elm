module Report.Report exposing (BalanceSheet)

type alias BalanceSheet =
    { account_id : Int
    , amount : Int
    , amount_exp : Int
    , time : String
    }
