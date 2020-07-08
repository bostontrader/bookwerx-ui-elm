module Account.Account exposing (..)

import Category.Category exposing (CategoryShort)
import Currency.Currency exposing (CurrencyShort, CurrencySymbol, currencySymbolDecoder)
import IntField exposing (IntField)
import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)



-- This alias and decoder directly matches a struct in bookwerx-core.


type alias AccountCurrency =
    { account_id : Int
    , title : String
    , currency : CurrencySymbol
    }


accountCurrencyDecoder : Decoder AccountCurrency
accountCurrencyDecoder =
    Json.Decode.succeed AccountCurrency
        |> required "account_id" int
        |> required "title" string
        |> required "currency" currencySymbolDecoder



-- Legacy aliai.  Clean this up


type alias Account =
    { id : Int
    , apikey : String
    , currency_id : Int
    , rarity : IntField
    , title : String
    }


type alias AccountJoined =
    { id : Int
    , apikey : String
    , categories : List CategoryShort
    , currency : CurrencyShort
    , rarity : IntField
    , title : String
    }
