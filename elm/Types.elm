module Types exposing
    ( BWCore_Error
    , Model
    , Msg(..)
    , Route(..)

    -- Accounts
      , Account
      , AccountId
      , AccountEditHttpResponse(..)
      
    -- Categories
      , Category
      , CategoryId
      , CategoryEditHttpResponse(..)

    -- Currencies
      , Currency
      , CurrencyEditHttpResponse(..)
      , CurrencyId

    -- Transactions
      , Transaction
      , TransactionEditHttpResponse(..)
      , TransactionId
    )

import Http
import Navigation exposing (Location)
import RemoteData exposing (WebData)

type AccountEditHttpResponse
    = ValidAccountEditResponse Account
    | ErrorAccountEditResponse (List BWCore_Error)

type CategoryEditHttpResponse
    = ValidCategoryEditResponse Category
    | ErrorCategoryEditResponse (List BWCore_Error)

type CurrencyEditHttpResponse
    = ValidCurrencyEditResponse Currency
    | ErrorCurrencyEditResponse (List BWCore_Error)

type TransactionEditHttpResponse
    = ValidTransactionEditResponse Transaction
    | ErrorTransactionEditResponse (List BWCore_Error)

type alias BWCore_Error =
    { key : String, value : String}

type alias Model =
    { currentRoute : Route
     
    -- accounts 
      , accounts : WebData (List Account)
      , wdAccount : WebData AccountEditHttpResponse

      -- Use this to assemble a new record or edit an existing one
      , editAccount : Account

    -- categories 
      , categories : WebData (List Category)
      , wdCategory : WebData CategoryEditHttpResponse

      -- Use this to assemble a new record or edit an existing one
      , editCategory : Category

    -- currencies
      , currencies : WebData (List Currency)
      , wdCurrency : WebData CurrencyEditHttpResponse

      -- Use this to assemble a new record or edit an existing one
      , editCurrency : Currency

    -- transactions
      , transactions : WebData (List Transaction)
      , wdTransaction : WebData TransactionEditHttpResponse

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
    | FetchAccounts
    | AccountsReceived (WebData (List Account))

    -- add
    | CreateNewAccount
    | NewAccountTitle String
    | AccountCreated (Result Http.Error Account)

    -- edit
    | AccountReceived (WebData AccountEditHttpResponse)
    | UpdateAccountTitle String
    | SubmitUpdatedAccount
    | AccountUpdated (Result Http.Error Account)

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
    | CategoryCreated (Result Http.Error Category)

    -- edit
    | CategoryReceived (WebData CategoryEditHttpResponse)
    | UpdateCategoryTitle String
    | SubmitUpdatedCategory
    | CategoryUpdated (Result Http.Error Category)

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
    | CurrencyReceived (WebData CurrencyEditHttpResponse)
    | UpdateCurrencySymbol String
    | UpdateCurrencyTitle String
    | SubmitUpdatedCurrency
    | CurrencyUpdated (Result Http.Error Currency)

    -- delete
    | DeleteCurrency CurrencyId
    | CurrencyDeleted (Result Http.Error String)

    -- Transactions
    -- index
    | FetchTransactions
    | TransactionsReceived (WebData (List Transaction))

    -- add
    | CreateNewTransaction
    | NewTransactionDatetime String
    | NewTransactionNote String
    | TransactionCreated (Result Http.Error Transaction)

    -- edit
    | TransactionReceived (WebData TransactionEditHttpResponse)
    | UpdateTransactionDatetime String
    | UpdateTransactionNote String
    | SubmitUpdatedTransaction
    | TransactionUpdated (Result Http.Error Transaction)

    -- delete
    | DeleteTransaction TransactionId
    | TransactionDeleted (Result Http.Error String)

type Route
    = Home
    | NotFound

    -- Accounts
    | AccountsIndex
    | AccountsAdd
    | AccountsEdit String

    -- Categories
    | CategoriesIndex
    | CategoriesAdd
    | CategoriesEdit String

    -- Currencies
    | CurrenciesIndex
    | CurrenciesAdd
    | CurrenciesEdit String

    -- Transactions
    | TransactionsIndex
    | TransactionsAdd
    | TransactionsEdit String