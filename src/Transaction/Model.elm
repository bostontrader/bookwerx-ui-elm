module Transaction.Model exposing (Model)

import RemoteData exposing (WebData)
import Transaction.Transaction exposing (Transaction)


type alias Model =
    -- wdTransactions is the 4 state RemoteData response from GetMany.  If the response is "success" the response is a raw string that shall be decoded as a List of Transaction and stored in transactions, -or- if it cannot be decoded it shall be assumed to be an error reported from the server.
    { transactions : List Transaction -- JSON decoded from wdTransactions
    , wdTransactions : WebData String -- the raw string response from GetMany
    , wdTransaction : WebData String
    , editBuffer : Transaction
    }
