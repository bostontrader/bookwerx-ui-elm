module Types exposing
    ( --BWCore_Error
    --, Flags
    --, FlashMsg
    --, FlashSeverity(..)
    RouteProxied(..)
    )

import Http
import Json.Decode exposing ( .. )
import Json.Decode.Pipeline exposing ( decode, required )
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Time exposing (Time)

import Account.AccountMsgB exposing ( AccountMsgB(..) )
import Category.CategoryMsgB exposing ( CategoryMsgB(..) )
import Currency.CurrencyMsgB exposing ( CurrencyMsgB(..) )
import Transaction.TransactionMsgB exposing ( TransactionMsgB(..) )


--type alias Flags =
--  { bwcoreHost : String
--  , bwcorePort : Int
--  }


--type alias BWCore_Error =
--    { key : String, value : String}


-- This is for the FlashMsg
--type FlashSeverity
--    = FlashSuccess
--    | FlashWarning
--    | FlashError


--type alias FlashMsg =
--    { message : String
    --, severity : FlashSeverity
--    , id : Int
--    , expirationTime : Time
--    }


-- These routes are required by the app, but are proxied by this server to a bookwerx-core backend.
type RouteProxied
    -- Accounts
    = AccountsDelete
    | AccountsGetMany
    | AccountsGetOne
    | AccountsPatch
    | AccountsPost

    -- Categories
    | CategoriesDelete
    | CategoriesGetMany
    | CategoriesGetOne
    | CategoriesPatch
    | CategoriesPost

    -- Currencies
    | CurrenciesDelete
    | CurrenciesGetMany
    | CurrenciesGetOne
    | CurrenciesPatch
    | CurrenciesPost

    -- Transactions
    | TransactionsDelete
    | TransactionsGetMany
    | TransactionsGetOne
    | TransactionsPatch
    | TransactionsPost
