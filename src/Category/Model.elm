module Category.Model exposing (Model)

import Category.Category exposing (Category)
import IntField exposing (IntField(..))
import RemoteData exposing (WebData)


type alias Model =
    -- wdCategories is the 4 state RemoteData response from GetMany.  If the response is "success" the response is a raw string that shall be decoded as a List of Category and stored in categories, -or- if it cannot be decoded it shall be assumed to be an error reported from the server.
    { categories : List Category -- JSON decoded from wdCategories
    , wdCategories : WebData String -- the raw string response from GetMany
    , wdCategory : WebData String
    , editBuffer : Category
    , rarityFilter : IntField
    }
