module Currency.MsgB exposing (MsgB(..))

import Currency.Currency exposing (Currency)
import Currency.Plumbing
    exposing
        ( CurrencyPostHttpResponseString
        , CurrencyPutHttpResponseString
        )
import RemoteData exposing (WebData)


type
    MsgB
    -- delete
    = DeleteCurrency String -- url
    | CurrencyDeleted (WebData String)
      -- getMany
    | GetManyCurrencies String
    | CurrenciesReceived (WebData String)
      -- getOne
    | GetOneCurrency String
    | CurrencyReceived (WebData String)
      -- put
    | PutCurrency String String String -- url content-type body
    | CurrencyPutted (WebData CurrencyPutHttpResponseString)
      -- post
    | PostCurrency String String String -- url content-type body
    | CurrencyPosted (WebData CurrencyPostHttpResponseString)
      -- edit
    | UpdateSymbol String
    | UpdateTitle String
