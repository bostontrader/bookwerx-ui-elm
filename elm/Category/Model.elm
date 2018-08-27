module Category.Model exposing ( Model )

import RemoteData exposing (WebData)

import Category.Plumbing exposing ( CategoryGetOneHttpResponse )
import Category.Category exposing (Category)

type alias Model =
    { categories : WebData (List Category)
    , wdCategory : WebData CategoryGetOneHttpResponse
    , editCategory : Category
    }