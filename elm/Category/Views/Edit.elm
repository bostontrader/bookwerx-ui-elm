module Category.Views.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Template exposing (template)
import Msg exposing ( Msg( CategoryMsgA ) )
import Model
import ViewHelpers exposing ( viewErrors, viewFlash )

import Category.Model
import Category.Plumbing exposing ( CategoryGetOneHttpResponse(..) )

import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing
    ( CategoryMsgB
        ( PatchCategory, UpdateCategoryTitle )
    )


view : Model.Model -> Html Msg
view model =
    template (div [ id "categories-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Category" ]
        , viewFlash model.flashMessages
        , a [ id "categories-index", href "/#ui/categories" ] [ text "Categories index" ]
        , viewCategoryOrError model.categories
        ])


viewCategoryOrError : Category.Model.Model -> Html Msg
viewCategoryOrError model =
    case model.wdCategory of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success response ->
            case response of
                CategoryGetOneDataResponse wdCategory ->
                    editForm model.editCategory

                CategoryGetOneErrorsResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Category error..." ]


editForm : Category -> Html Msg
editForm category =
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
                    , value category.title
                    , onInput ( \newValue -> CategoryMsgA (UpdateCategoryTitle newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (CategoryMsgA PatchCategory) ]
                [ text "Submit" ]
            ]
        ]