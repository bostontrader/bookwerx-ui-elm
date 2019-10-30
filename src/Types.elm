module Types exposing
    ( AEMode(..)
    , DRCR(..)
    , DRCRFormat(..)
    )

--import Category.MsgB exposing ( MsgB(..) )
--import Currency.MsgB exposing (MsgB(..))

--import Account.MsgB exposing (AccountMsgB(..))
--import Bserver.MsgB exposing (MsgB(..))
--import Http
--import Json.Decode exposing (..)
--import Json.Decode.Pipeline exposing (decode, required)
--import Navigation exposing (Location)
--import RemoteData exposing (WebData)
--import Time exposing (Time)
--import Transaction.MsgB exposing (MsgB(..))



--type alias Flags =
--  { bwcoreHost : String
--  , bwcorePort : Int
--  }
--type alias BWCore_Error =
--    { key : String, value : String}
-- This is for the FlashMsg

-- These routes are required by the app, but are proxied by this server to a bookwerx-core backend.

type DRCR
    = DR
    | CR

type DRCRFormat
    = DRCR
    | PlusAndMinus

--type Language
    --= English
    --| Chinese
    --| Pinyin



-- The add and edit functionality are very close together.  How can we unify them?  Start with this.


type AEMode
    = Add
    | Edit


--type
    --RouteProxied
    -- Accounts
    --= AccountsDelete
    --| AccountsGetMany
    --| AccountsGetOne
    --| AccountsPatch
    --| AccountsPost
      -- Apikeys
      --| ApikeysTestConn
      -- Bservers
    --| BserversPing
      -- Categories
      --| CategoriesDelete
      --| CategoriesGetMany
      --| CategoriesGetOne
      --| CategoriesPatch
      --| CategoriesPost
      -- Currencies
    --| CurrenciesDelete
    --| CurrenciesGetMany
    --| CurrenciesGetOne
    --| CurrenciesPatch
    --| CurrenciesPost
      -- Distributions
    --| DistributionsDelete
    --| DistributionsGetMany
    --| DistributionsGetOne
    --| DistributionsPatch
    --| DistributionsPost
      -- Transactions
    --| TransactionsDelete
    --| TransactionsGetMany
    --| TransactionsGetOne
    --| TransactionsPatch
    --| TransactionsPost



-- When implementing a controlled input for an integer
--type IntField
--    = IntField (Maybe Int) String
