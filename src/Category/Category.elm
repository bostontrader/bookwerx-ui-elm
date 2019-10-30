module Category.Category exposing (Category, CategoryShort)

type alias Category =
    { id : Int
    , apikey : String
    , symbol : String
    , title : String
    }


-- Need this for the convenience of the UI
type alias CategoryShort =
    { category_symbol : String }
