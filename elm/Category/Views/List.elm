module Category.Views.List exposing (view)

import Html exposing (Html, a, button, div, h3, table, tbody, td, thead, text, th, tr)
import Html.Attributes exposing (class, href, id, style)
import Html.Events exposing (onClick)
import Http
import RemoteData

import Model
import Msg exposing ( Msg( CategoryMsgA ) )
import Template exposing (template)
import ViewHelpers exposing ( viewFlash )

import Category.Model
import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing ( CategoryMsgB ( DeleteCategory ) )


view : Model.Model -> Html Msg
view model =
    template (div []
        [ h3 [ class "title is-3" ] [ text "Categories" ]
        , viewFlash model.flashMessages
        ,  a [ id "categories-add", href "/#ui/categories/add", class "button is-link" ]
            [ text "Create new category" ]
        , viewCategoriesOrError model.categories
        ])


viewCategoriesOrError : Category.Model.Model -> Html Msg
viewCategoriesOrError model =
    case model.categories of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success categories ->
            if List.isEmpty categories then
              div [ id "categories-index" ]
              [ h3 [ id "categories-empty" ][ text "No categories present" ] ]
            else
              div [ id "categories-index", style [("margin-top","1.0em")] ]
              (viewCategories categories)

        RemoteData.Failure httpError ->
            h3 [] [ text "Categories error..." ]


viewCategories : List Category -> List (Html Msg)
viewCategories categories =
    [ table [ class "table is-striped" ]
        [ thead [][viewTableHeader]
        , tbody [] (List.map viewCategory categories)
        ]
    ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th [][ text "ID" ]
        , th [][ text "Title" ]
        , th [][] -- extra headers for edit and delete
        , th [][]
        ]


viewCategory : Category -> Html Msg
viewCategory category =
    let
        categoryPath =
            "/#ui/categories/" ++ category.id
    in
        tr []
            [ td [] [ text category.id ]
            , td [] [ text category.title ]
            , td []
                [ a [ id "categories-edit", href categoryPath, class "button is-link" ] [ text "Edit" ] ]
            -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
            , td [ id "deleteCategory" ]
                [ button [ class "button is-link is-danger", onClick ( CategoryMsgA ( DeleteCategory category.id) ) ]
                    [ text "Delete" ]
                ]
            ]
