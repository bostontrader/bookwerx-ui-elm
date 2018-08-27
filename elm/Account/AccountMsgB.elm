module Account.AccountMsgB exposing ( AccountMsgB (..) )

import Http
import RemoteData exposing ( WebData )

import Account.Plumbing exposing
    ( AccountId
    , AccountGetOneHttpResponse
    , AccountPatchHttpResponse
    , AccountPostHttpResponse
    )

import Account.Account exposing ( Account )

type AccountMsgB
    -- delete
    = DeleteAccount AccountId
    | AccountDeleted (Result Http.Error String)

    -- getMany
    | AccountsReceived (WebData (List Account))

    -- getOne
    | AccountReceived (WebData AccountGetOneHttpResponse)

    -- patch
    | PatchAccount
    | AccountPatched (WebData AccountPatchHttpResponse)

    -- post
    | PostAccount
    | AccountPosted (WebData AccountPostHttpResponse)

    -- edit
    | UpdateAccountTitle String
