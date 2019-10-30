module Transaction.Transaction exposing (Transaction)


type alias Transaction =
    { id : Int
    , apikey : String
    , notes : String
    , time : String
    }
