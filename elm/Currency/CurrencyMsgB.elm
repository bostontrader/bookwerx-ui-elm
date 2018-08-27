module Currency.CurrencyMsgB exposing ( CurrencyMsgB (..) )

import Http
import RemoteData exposing ( WebData )

import Currency.Plumbing exposing
    ( CurrencyId
    , CurrencyGetOneHttpResponse
    , CurrencyPatchHttpResponse
    , CurrencyPostHttpResponse
    )

import Currency.Currency exposing ( Currency )

type CurrencyMsgB
    -- delete
    = DeleteCurrency CurrencyId
    | CurrencyDeleted (Result Http.Error String)

    -- getMany
    | CurrenciesReceived (WebData (List Currency))

    -- getOne
    | CurrencyReceived (WebData CurrencyGetOneHttpResponse)

    -- patch
    | PatchCurrency
    | CurrencyPatched (WebData CurrencyPatchHttpResponse)

    -- post
    | PostCurrency
    | CurrencyPosted (WebData CurrencyPostHttpResponse)

    -- edit
    | UpdateCurrencySymbol String
    | UpdateCurrencyTitle String
