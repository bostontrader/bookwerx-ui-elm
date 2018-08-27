module Transaction.Transaction exposing ( Transaction )

type alias Transaction =
    { id : String
    , datetime : String
    , note : String
    }
