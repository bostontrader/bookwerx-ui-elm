module Transaction.MsgB exposing (MsgB(..))

import RemoteData exposing (WebData)
import Transaction.Plumbing
    exposing
        ( TransactionPostHttpResponseString
        , TransactionPutHttpResponseString
        )


type
    MsgB
    -- delete
    = DeleteTransaction String -- url
    | TransactionDeleted (WebData String)
      -- getMany
    | GetManyTransactions String
    | TransactionsReceived (WebData String)
      -- getOne
    | GetOneTransaction String
    | TransactionReceived (WebData String)
      -- put
    | PutTransaction String String String -- url content-type body
    | TransactionPutted (WebData TransactionPutHttpResponseString)
      -- post
    | PostTransaction String String String -- url content-type body
    | TransactionPosted (WebData TransactionPostHttpResponseString)
      -- edit
    | UpdateNotes String
    | UpdateTime String
