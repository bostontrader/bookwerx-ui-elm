module Category.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, label, text)
import Html.Attributes exposing (class, href, id, type_)
import Html.Events exposing (onClick, onInput)

import Template exposing (template)

import Model
import Msg exposing ( Msg( CategoryMsgA ) )
import ViewHelpers exposing ( viewFlash )

import Category.Model exposing ( Model )
import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing
    ( CategoryMsgB
        ( PostCategory, UpdateCategoryTitle )
    )


view : Model.Model -> Html Msg
view model =
    template (div [ id "categories-add" ]
        [ h3 [ class "title is-3" ] [ text "Create New Category" ]
        , viewFlash model.flashMessages
        , a [ id "categories-index",  href "/#ui/categories" ] [ text "Categories" ]
        , newCategoryForm model.categories.editCategory
        ])


newCategoryForm : Category -> Html Msg
newCategoryForm category =
    -- don't use form lest the subsequent post xhr get fubared
    -- Html.form []
    div []
        [ div [class "field"]
            [ label [class "label"][ text "Title"]
            , div [class "control"]
                [ input
                    [ id "title"
                    , class "input"
                    , type_ "text"
                    , onInput ( \newValue -> CategoryMsgA (UpdateCategoryTitle newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (CategoryMsgA PostCategory) ]
                [ text "Submit" ]
            ]
        ]