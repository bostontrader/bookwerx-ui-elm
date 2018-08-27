module Transaction.TransactionMsgB exposing ( TransactionMsgB (..) )

import Http
import RemoteData exposing ( WebData )

import Transaction.Plumbing exposing
    ( TransactionId
    , TransactionGetOneHttpResponse
    , TransactionPatchHttpResponse
    , TransactionPostHttpResponse
    )

import Transaction.Transaction exposing ( Transaction )

type TransactionMsgB
    -- delete
    = DeleteTransaction TransactionId
    | TransactionDeleted (Result Http.Error String)

    -- getMany
    | TransactionsReceived (WebData (List Transaction))

    -- getOne
    | TransactionReceived (WebData TransactionGetOneHttpResponse)

    -- patch
    | PatchTransaction
    | TransactionPatched (WebData TransactionPatchHttpResponse)

    -- post
    | PostTransaction
    | TransactionPosted (WebData TransactionPostHttpResponse)

    -- edit
    | UpdateTransactionDatetime String
    | UpdateTransactionNote String
