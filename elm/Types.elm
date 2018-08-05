module Types exposing
    ( errorResponseDecoder
    , BWCore_Error
    , Flags
    , Model
    , Msg(..)
    , Route(..)
    , RouteProxied(..)

    -- Accounts
      , Account
      , AccountId
      , AccountPostHttpResponse(..)
      , AccountPatchHttpResponse(..)

    -- Categories
      , Category
      , CategoryId
      , CategoryPostHttpResponse(..)
      , CategoryPatchHttpResponse(..)

    -- Currencies
      , Currency
      , CurrencyId
      , CurrencyPostHttpResponse(..)
      , CurrencyPatchHttpResponse(..)

    -- Transactions
      , Transaction
      , TransactionPostHttpResponse(..)
      , TransactionPatchHttpResponse(..)
      , TransactionId
      , PostTransactionResult
    )

import Http
import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Navigation exposing (Location)
import RemoteData exposing (WebData)

type alias Flags =
  { bwcoreHost : String
  , bwcorePort : Int
  }

type AccountPostHttpResponse
    = ValidAccountPostResponse Account
    | ErrorAccountPostResponse (List BWCore_Error)

type AccountPatchHttpResponse
    = ValidAccountPatchResponse Account
    | ErrorAccountPatchResponse (List BWCore_Error)

type CategoryPostHttpResponse
    = ValidCategoryPostResponse Category
    | ErrorCategoryPostResponse (List BWCore_Error)

type CategoryPatchHttpResponse
    = ValidCategoryPatchResponse Category
    | ErrorCategoryPatchResponse (List BWCore_Error)

type CurrencyPostHttpResponse
    = ValidCurrencyPostResponse Currency
    | ErrorCurrencyPostResponse (List BWCore_Error)

type CurrencyPatchHttpResponse
    = ValidCurrencyPatchResponse Currency
    | ErrorCurrencyPatchResponse (List BWCore_Error)

type TransactionPostHttpResponse
    = ValidTransactionPostResponse Transaction
    | ErrorTransactionPostResponse (List BWCore_Error)

type TransactionPatchHttpResponse
    = ValidTransactionPatchResponse Transaction
    | ErrorTransactionPatchResponse (List BWCore_Error)

type alias PostTransactionResult =
    { n : Int, ok : Int }

type alias BWCore_Error =
    { key : String, value : String}

type alias Model =
    { currentRoute : Route
    , runtimeConfig : Flags

    -- accounts
      , accounts : WebData (List Account)
      , wdAccount : WebData AccountPostHttpResponse

      -- Use this to assemble a new record or edit an existing one
      , editAccount : Account

    -- categories 
      , categories : WebData (List Category)
      , wdCategory : WebData CategoryPostHttpResponse

      -- Use this to assemble a new record or edit an existing one
      , editCategory : Category

    -- currencies
      , currencies : WebData (List Currency)
      , wdCurrency : WebData CurrencyPostHttpResponse

      -- Use this to assemble a new record or edit an existing one
      , editCurrency : Currency

    -- transactions
      , transactions : WebData (List Transaction)
      , wdTransaction : WebData TransactionPostHttpResponse

      -- Use this to assemble a new record or edit an existing one
      , editTransaction : Transaction
    }

type alias AccountId =
    String

type alias Account =
    { id : String
    , title : String
    }

type alias CategoryId =
    String

type alias Category =
    { id : String
    , title : String
    }

type alias CurrencyId =
    String

type alias Currency =
    { id : String
    , symbol : String
    , title : String
    }

type alias TransactionId =
    String

type alias Transaction =
    { id : String
    , datetime : String
    , note : String
    }

type Msg
    = LocationChanged Location

    -- Accounts
    -- index
    -- | FetchAccounts
    | AccountsReceived (WebData (List Account))

    -- add
    | CreateNewAccount
    | NewAccountTitle String
    -- | AccountCreated (Result Http.Error Account)
    | AccountCreated (WebData AccountPostHttpResponse)

    -- edit
    | AccountReceived (WebData AccountPostHttpResponse)
    | UpdateAccountTitle String
    | SubmitUpdatedAccount
    -- | AccountUpdated (Result Http.Error Account)
    | AccountPatched (WebData AccountPatchHttpResponse)

    -- delete
    | DeleteAccount AccountId
    | AccountDeleted (Result Http.Error String)

    -- Categories
    -- index
    | FetchCategories
    | CategoriesReceived (WebData (List Category))

    -- add
    | CreateNewCategory
    | NewCategoryTitle String
    -- | CategoryCreated (Result Http.Error Category)
    | CategoryCreated (WebData CategoryPostHttpResponse)

    -- edit
    | CategoryReceived (WebData CategoryPostHttpResponse)
    | UpdateCategoryTitle String
    | SubmitUpdatedCategory
    -- | CategoryUpdated (Result Http.Error Category)
    | CategoryPatched (WebData CategoryPatchHttpResponse)

    -- delete
    | DeleteCategory CategoryId
    | CategoryDeleted (Result Http.Error String)

    -- Currencies
    -- index
    | FetchCurrencies
    | CurrenciesReceived (WebData (List Currency))

    -- add
    | CreateNewCurrency
    | NewCurrencySymbol String
    | NewCurrencyTitle String
    | CurrencyCreated (Result Http.Error Currency)

    -- edit
    | CurrencyReceived (WebData CurrencyPostHttpResponse)
    | UpdateCurrencySymbol String
    | UpdateCurrencyTitle String
    | SubmitUpdatedCurrency
    | CurrencyUpdated (Result Http.Error Currency)

    -- delete
    | DeleteCurrency CurrencyId
    | CurrencyDeleted (Result Http.Error String)

    -- Transactions
    -- index
    --| FetchTransactions
    | TransactionsReceived (WebData (List Transaction))

    -- add
    | CreateNewTransaction
    | NewTransactionDatetime String
    | NewTransactionNote String
    --| TransactionCreated (Result Http.Error Transaction)
    --| TransactionCreated (Result Http.Error String)
    --| TransactionCreated (WebData PostTransactionResult)
    | TransactionCreated (WebData TransactionPostHttpResponse)

    -- edit
    | TransactionReceived (WebData TransactionPostHttpResponse)
    | UpdateTransactionDatetime String
    | UpdateTransactionNote String
    | SubmitUpdatedTransaction
    --| TransactionUpdated (Result Http.Error Transaction)
    | TransactionPatched (WebData TransactionPatchHttpResponse)

    -- delete
    | DeleteTransaction TransactionId
    | TransactionDeleted (Result Http.Error String)

-- These are the UI routes that this server directly supports
type Route
    = Home
    | NotFound

    -- Accounts
    | AccountsAdd
    | AccountsEdit String
    | AccountsIndex

    -- Categories
    | CategoriesAdd
    | CategoriesEdit String
    | CategoriesIndex

    -- Currencies
    | CurrenciesAdd
    | CurrenciesEdit String
    | CurrenciesIndex

    -- Transactions
    | TransactionsAdd
    | TransactionsEdit String
    | TransactionsIndex


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


type alias Error =
    { key : String, value : String }

type alias ErrorResponse =
    { errors : List Error }

errorDecoder : Json.Decode.Decoder Error
errorDecoder =
    Json.Decode.Pipeline.decode Error
        |> Json.Decode.Pipeline.required "key" Json.Decode.string
        |> Json.Decode.Pipeline.required "value" Json.Decode.string

errorListDecoder : Json.Decode.Decoder (List Error)
errorListDecoder =
    Json.Decode.list errorDecoder

errorResponseDecoder : Json.Decode.Decoder ErrorResponse
errorResponseDecoder =
    Json.Decode.Pipeline.decode ErrorResponse
        |> Json.Decode.Pipeline.required "errors" errorListDecoder
