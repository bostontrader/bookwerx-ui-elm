module Transaction.Model exposing ( Model )

import RemoteData exposing (WebData)

import Transaction.Plumbing exposing ( TransactionGetOneHttpResponse )
import Transaction.Transaction exposing (Transaction)

type alias Model =
    { transactions : WebData (List Transaction)
    , wdTransaction : WebData TransactionGetOneHttpResponse
    , editTransaction : Transaction
    }