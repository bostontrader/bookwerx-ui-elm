module Types exposing
    ( Model
    , Msg(..)
    , Currency
    , CurrencyId
    , Route(..)
    )

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Http

type alias Currency =
    { id : String
    , symbol : String
    , title : String
    }


type alias Model =
    { currencies : WebData (List Currency)
    , currentRoute : Route
    , newCurrency : Currency
    }

type alias CurrencyId =
    String

type Msg
    = FetchCurrencies
    | CurrenciesReceived (WebData (List Currency))
    | LocationChanged Location
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
    = CurrenciesAdd
    | CurrenciesEdit Int
    | CurrenciesIndex
    | Home
    | NotFound
