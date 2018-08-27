module Account.Plumbing exposing
    ( AccountId
    , AccountGetOneHttpResponse(..)
    , AccountPatchHttpResponse(..)
    , AccountPostHttpResponse(..)
    , PostAccountResponse
    )

import RemoteData exposing ( WebData )

import TypesB exposing ( BWCore_Error, FlashMsg )

import Account.Account exposing ( Account )


type alias AccountId = String

type AccountGetOneHttpResponse
    = AccountGetOneDataResponse Account
    | AccountGetOneErrorsResponse (List BWCore_Error)

type AccountPatchHttpResponse
    = AccountPatchDataResponse Account
    | AccountPatchErrorsResponse (List BWCore_Error)

type AccountPostHttpResponse
    = AccountPostDataResponse PostAccountResponse
    | AccountPostErrorsResponse (List BWCore_Error)

type alias PostAccountResponse = { insertedId : String }