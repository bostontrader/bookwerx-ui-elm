module Account.Account exposing (Account, AccountJoined)

import Category.Category exposing (CategoryShort)
import Currency.Currency exposing (CurrencyShort)
import IntField exposing (IntField)


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
