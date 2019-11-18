module Currency.Currency exposing (Currency, CurrencyShort)

import IntField exposing (IntField)


type alias Currency =
    { id : Int
    , apikey : String
    , rarity : IntField
    , symbol : String
    , title : String
    }



-- Need this for the convenience of the UI


type alias CurrencyShort =
    { symbol : String
    , title : String
    }
