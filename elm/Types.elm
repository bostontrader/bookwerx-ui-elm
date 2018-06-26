module Types exposing
    ( BWCore_Error
    , Model
    , Msg(..)
    , Route(..)
    , Account
    , AccountId
    , Currency
    , CurrencyEditHttpResponse(..)
    , CurrencyId
    )

import Http
import Navigation exposing (Location)
import RemoteData exposing (WebData)

type CurrencyEditHttpResponse
    = ValidCurrencyEditResponse Currency
    | ErrorCurrencyEditResponse (List BWCore_Error)

type alias BWCore_Error =
    { key : String, value : String}

type alias Model =
    { currentRoute : Route
     
    , accounts : WebData (List Account)
    , account : WebData (Account)
    , newAccount : Account

    , currencies : WebData (List Currency)
    , currency : WebData CurrencyEditHttpResponse
    , newCurrency : Currency

    }

type alias AccountId =
    String

type alias Account =
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

type Msg
    = LocationChanged Location

    -- Accounts
    | FetchAccounts
    | FetchAccount AccountId
    | AccountsReceived (WebData (List Account))
    | AccountReceived (WebData Account)
    --| UpdateAccountSymbol AccountId String
    --| UpdateAccountTitle AccountId String
    --| SubmitUpdatedAccount AccountId
    --| AccountUpdated (Result Http.Error Account)
    | DeleteAccount AccountId
    | AccountDeleted (Result Http.Error String)
    --| NewAccountSymbol String
    | NewAccountTitle String
    | CreateNewAccount
    | AccountCreated (Result Http.Error Account)

    -- Currencies
    -- index
    | FetchCurrencies
    | CurrenciesReceived (WebData (List Currency))

    -- edit
    | CurrencyReceived (WebData CurrencyEditHttpResponse)

    --| UpdateCurrencySymbol CurrencyId String
    --| UpdateCurrencyTitle CurrencyId String
    --| SubmitUpdatedCurrency CurrencyId
    --| CurrencyUpdated (Result Http.Error Currency)
    | DeleteCurrency CurrencyId
    | CurrencyDeleted (Result Http.Error String)
    | NewCurrencySymbol String
    | NewCurrencyTitle String
    | CreateNewCurrency
    | CurrencyCreated (Result Http.Error Currency)

type Route
    = Home
    | NotFound

    -- Accounts
    | AccountsAdd
    | AccountsEdit String
    | AccountsIndex

    -- Currencies
    | CurrenciesIndex
    | CurrenciesAdd
    | CurrenciesEdit String
