module Categories.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (class, href, id, type_)
import Html.Events exposing (onClick, onInput)

import Template exposing (template)
import Types exposing
    ( Category
    , Model
    , Msg(CreateNewCategory, NewCategoryTitle)
    )


view : Model -> Html Msg
view model =
    template (div [ id "categories-add" ]
        [ h3 [ class "title is-3" ] [ text "Create New Category" ]
        , a [ id "categories-index",  href "/ui/categories" ] [ text "Categories" ]
        , newCategoryForm model.editCategory
        ])


newCategoryForm : Category -> Html Msg
newCategoryForm category =
    Html.form []
        [ div []
            [ text "Title"
            , br [][]
            , input
                [ id "title", type_ "text"
                , onInput NewCategoryTitle
                ]
                []
            ]
        , br [][]
        , div []
            [ button
                [ id "save"
                , onClick CreateNewCategory
                ]
                [ text "Submit" ]
            ]
        ]